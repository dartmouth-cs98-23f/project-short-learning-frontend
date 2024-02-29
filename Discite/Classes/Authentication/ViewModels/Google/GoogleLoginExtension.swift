//
//  GoogleLogin.swift
//  Discite
//
//  Created by Jessie Li on 2/28/24.
//

// import Foundation
// import GoogleSignIn
// import SwiftUI
//
// extension LoginViewModel {
//    // Try to restore Google sign in state
//    @MainActor
//    public func restoreGoogleSignIn(user: User) {
//        isLoading = true
//        error = nil
//        
//        // Check if `user` exists; otherwise, do something with `error`
//        GIDSignIn.sharedInstance.restorePreviousSignIn { googleUser, error in
//            guard error == nil else {
//                self.error = error
//                return
//            }
//            
//            guard let googleUser = googleUser else { return }
//            guard let idToken = googleUser.idToken else { return }
//            
//            Task {
//                // Send ID token to backend and set global user
//                let response = try await AuthenticationService.mockGoogleLogin(idToken: idToken.tokenString)
//                try user.configure(data: response)
//            }
//        }
//        
//        self.isLoading = false
//    }
//    
//    // Sign in with Google
//    func googleSignIn(user: User) {
//        isLoading = true
//        error = nil
//        
//        guard let presentingViewController =
//                (UIApplication.shared.connectedScenes.first
//                as? UIWindowScene)?.windows.first?.rootViewController
//                
//        else {
//            self.error = AuthError.noRootController
//            return
//        }
//        
//        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
//            guard error == nil else {
//                self.error = error
//                return
//            }
//            
//            guard let googleUser = signInResult?.user else {
//                self.error = AuthError.failedSignIn
//                return
//            }
//            
//            googleUser.refreshTokensIfNeeded { googleUser, error in
//                guard
//                    error == nil,
//                    let googleUser = googleUser,
//                    let idToken = googleUser.idToken
//                        
//                else {
//                    self.error = AuthError.tokenError
//                    return
//                }
//                
//                Task {
//                    // Send ID token to backend and set global user
//                    let response = try await AuthenticationService.mockGoogleLogin(idToken: idToken.tokenString)
//                    try await user.configure(data: response)
//                }
//
//                self.isLoading = false
//            }
//        }
//    }
//    
// }
