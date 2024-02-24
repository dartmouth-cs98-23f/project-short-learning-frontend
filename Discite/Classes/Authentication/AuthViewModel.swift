//
//  AuthViewModel.swift
//  Discite
//
//  Created by Jessie Li on 2/23/24.
//
//  Source:
//      https://paulallies.medium.com/google-sign-in-swiftui-2909e01ea4ed
//      https://developers.google.com/identity/sign-in/ios/start-integrating
//      https://developers.google.com/identity/sign-in/ios/sign-in#using-swiftui

import SwiftUI
import GoogleSignIn

public enum AuthStatus: String, Identifiable, CaseIterable {
    case loggedOut
    case onboarding
    case loggedIn

    public var id: String { rawValue }
}

public enum AuthError: Error {
    case noRootController
    case failedSignIn
    case noToken
}

// Google Auth View Model
class AuthViewModel: ObservableObject {
    static let shared = AuthViewModel()
    
    @Published var status: AuthStatus = .loggedOut
    @Published var error: Error?
    @Published var isLoading: Bool = false
    
    init() {
        checkPreviousSignIn()
    }
    
    // Update status to show onboarded completed
    func onboardingComplete() {
        User.shared?.onboarded = true
        
        withAnimation(.spring) {
            status = .loggedIn
        }
    }
    
    // Set user to default anonymous user
    func setPreviewMode() {
        User.shared = User.anonymousUser
        
        withAnimation(.spring) {
            self.status = .onboarding
        }
    }
    
    // Set current user info with properties from Google account
    func setCurrentUser(user: GIDGoogleUser) {
        let currentUser = User(userId: user.userID ?? "",
                               firstName: user.profile?.givenName ?? "",
                               lastName: user.profile?.familyName ?? "",
                               username: (user.profile?.email.components(separatedBy: "@").first ?? user.userID) ?? "",
                               email: user.profile?.email ?? "",
                               profilePicture: user.profile?.imageURL(withDimension: 100)?.absoluteString)
        
        User.shared = currentUser
    }
    
    // Try to restore Google sign in state
    func checkPreviousSignIn() {
        isLoading = true
        error = nil
        
        // Check if `user` exists; otherwise, do something with `error`
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            guard error == nil else {
                self.error = error
                return
            }
            
            guard let user = user else { return }
            guard let idToken = user.idToken else { return }
            
            self.setCurrentUser(user: user)
            
            Task {
                // Send ID token to backend and set global user
                let response = try await AuthenticationService.mockGoogleLogin(idToken: idToken.tokenString)
                User.shared?.onboarded = response.onboarded
                
                withAnimation(.spring) {
                    self.status = response.onboarded ? .loggedIn : .onboarding
                    self.isLoading = false
                }
            }
        }
    }
    
    // Sign in with Google
    func googleSignIn() {
        isLoading = true
        error = nil
        
        guard let presentingViewController =
                (UIApplication.shared.connectedScenes.first
                as? UIWindowScene)?.windows.first?.rootViewController
                
        else {
            self.error = AuthError.noRootController
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
            guard error == nil else {
                self.error = error
                return
            }
            
            guard let googleUser = signInResult?.user else {
                self.error = AuthError.failedSignIn
                return
            }
            
            // Manually set user info for now, in case backend is unable to retreive from token (below)
            self.setCurrentUser(user: googleUser)
            
            googleUser.refreshTokensIfNeeded { user, error in
                guard
                    error == nil,
                    let user = user,
                    let idToken = user.idToken
                        
                else {
                    self.error = AuthError.noToken
                    return
                }
                
                Task {
                    // Send ID token to backend and set global user
                    let response = try await AuthenticationService.mockGoogleLogin(idToken: idToken.tokenString)
                    User.shared?.onboarded = response.onboarded
                    // User.shared = response
                    
                    withAnimation(.spring) {
                        self.status = .loggedIn
                        self.isLoading = false
                    }
                }
            }
        }
    }
    
    // Sign out with Google
    func googleSignOut() {
        GIDSignIn.sharedInstance.signOut()
        User.shared = nil

        withAnimation(.spring) {
            status = .loggedOut
        }
    }

}
