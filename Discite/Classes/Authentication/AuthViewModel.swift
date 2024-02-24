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
    case loading
    case error
    case loggedOut
    case onboarding
    case loggedIn

    public var id: String { rawValue }
}

class AuthViewModel: ObservableObject {

    @Published var status: AuthStatus = .loggedOut
    @Published var error: Error?
    var user: User?
    
    // For the login page
    @Published var usernameOrEmail: String = "johndoe"
    @Published var password: String = "abc123"
    
    init() {
        checkPreviousSignIn()
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
                self.status = .loggedIn
            }
        }
    }
    
    func googleSignIn() {
        guard let presentingViewController = 
                (UIApplication.shared.connectedScenes.first
                as? UIWindowScene)?.windows.first?.rootViewController
                
        else { return }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
            guard error == nil else {
                self.error = error
                return
            }
            
            guard let signInResult = signInResult else { return }
            
            signInResult.user.refreshTokensIfNeeded { user, error in
                guard error == nil else { return }
                guard let user = user else { return }

                guard let idToken = user.idToken else { return }
                
                Task {
                    // Send ID token to backend and set global user
                    let response = try await AuthenticationService.mockGoogleLogin(idToken: idToken.tokenString)
                    self.user = response
                    self.status = .loggedIn
                }
            }
        }
    }
    
    func googleSignOut() {
        GIDSignIn.sharedInstance.signOut()
        status = .loggedOut
    }
    
    func login() async {
        status = .loading
        
        do {
            let response = try await AuthenticationService.mockLogin(
                parameters: LoginRequest(
                    email: usernameOrEmail,
                    password: password))
            
            try Auth.shared.setToken(token: response.token)
            status = .loggedIn
            
        } catch {
            print("Login failed: \(error)")
            self.error = error
            status = .error
        }
    }
}
