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

class AuthViewModel: ObservableObject {
    static let shared = AuthViewModel()
    
    @Published var status: AuthStatus = .loggedOut
    @Published var error: Error?
    @Published var isLoading: Bool = false
    
    // For the login page
    @Published var usernameOrEmail: String = "johndoe"
    @Published var password: String = "abc123"
    
    var user: User?
    
    init() {
        checkPreviousSignIn()
    }
    
    func updateStatus() {
        withAnimation(.spring) {
            if let user = self.user, user.onboarded {
                status = .loggedIn
            } else if self.user != nil {
                status = .onboarding
            } else {
                status = .loggedOut
            }
        }
    }
    
    func onboardingComplete() {
        print("onboarding complete")
        if let user {
            user.onboarded = true
        }
        
        withAnimation(.spring) {
            status = .loggedIn
        }
    }
    
    func setPreviewMode() {
        self.user = User.anonymousUser
        
        withAnimation(.spring) {
            self.status = .onboarding
        }
    }
    
    func checkPreviousSignIn() {
        // Check if `user` exists; otherwise, do something with `error`
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            guard error == nil else {
                self.error = error
                return
            }
            
            guard let user = user else { return }
            guard let idToken = user.idToken else { return }
            
            Task {
                // Send ID token to backend and set global user
                let response = try await AuthenticationService.mockGoogleLogin(idToken: idToken.tokenString)
                self.user = response
                
                self.updateStatus()
            }
        }
    }
    
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
            
            guard let signInResult = signInResult else {
                self.error = AuthError.failedSignIn
                return
            }
            
            signInResult.user.refreshTokensIfNeeded { user, error in
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
                    self.user = response
                    
                    withAnimation(.spring) {
                        self.status = .loggedIn
                        self.isLoading = false
                    }
                }
            }
        }
    }
    
    func googleSignOut() {
        GIDSignIn.sharedInstance.signOut()
        self.user = nil

        withAnimation(.spring) {
            status = .loggedOut
        }
    }
    
    func login() async {
        isLoading = true
        error = nil
        
        do {
            let response = try await AuthenticationService.mockLogin(
                parameters: LoginRequest(
                    email: usernameOrEmail,
                    password: password))
            
            try Auth.shared.setToken(token: response.token)
            updateStatus()
            isLoading = false
            
        } catch {
            print("Login failed: \(error)")
            self.error = error
        }
    }
}
