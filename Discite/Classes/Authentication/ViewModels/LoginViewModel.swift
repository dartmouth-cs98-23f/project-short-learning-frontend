//
//  LoginViewModel.swift
//  Discite
//
//  Created by Jessie Li on 10/14/23.
//

import SwiftUI
import Foundation
import AuthenticationServices

class LoginViewModel: ObservableObject {
    enum AuthError: Error {
        case noRootController
        case failedSignIn
        case tokenError
    }
    
    enum AuthType: String, CaseIterable {
        case custom
        case google
        case apple
    }
    
    @Published var usernameOrEmail: String = "johndoe"
    @Published var password: String = "abc123"
    @Published var error: Error?
    @Published var isLoading = false
    
    // Sets user to guest (for preview mode)
    @MainActor
    func setPreviewMode(user: User) {
        user.configure()
    }
    
    // Default sign in with our own authentication
    func signIn(user: User) async {
        isLoading = true
            
        do {
            let data = try await AuthenticationService.mockLogin(
                parameters: LoginRequest(
                    email: usernameOrEmail,
                    password: password))
            
            try user.configure(data: data)
            
        } catch {
            print("Login failed: \(error)")
            self.error = error
        }
        
        isLoading = false
    }
}
