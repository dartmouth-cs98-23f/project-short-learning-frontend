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

class AuthViewModel: ObservableObject {

    @Published var isLoggedIn: Bool = false
    @Published var error: Error?
    @Published var user: User?
    
    
    init() {
        checkPreviousSignIn()
    }
    
    func checkStatus() {
        self.isLoggedIn = (GIDSignIn.sharedInstance.currentUser != nil
                           && user != nil)
    }
    
    func checkPreviousSignIn() {
        // Check if `user` exists; otherwise, do something with `error`
        GIDSignIn.sharedInstance.restorePreviousSignIn { _, error in
            if let error = error {
                self.error = error
            }
            
            self.checkStatus()
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
                }
            }
            
            self.checkStatus()
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        self.checkStatus()
    }
}
