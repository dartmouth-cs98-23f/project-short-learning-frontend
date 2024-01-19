//
//  LoginViewModel.swift
//  Discite
//
//  Created by Jessie Li on 10/14/23.
//

import Foundation

class LoginViewModel: ObservableObject {
    
    @Published var usernameOrEmail: String = "johndoe"
    @Published var password: String = "abc123"
    @Published var error: Error?
    @Published var isLoading = false
    
    func login() async {
        
        isLoading = true
        
        do {
            let response = try await AuthenticationService.mockLogin(
                parameters: LoginRequest(
                    email: usernameOrEmail,
                    password: password))
            
            try Auth.shared.setToken(token: response.token)
            
        } catch {
            print("Login failed: \(error)")
            self.error = error
        }
        
        isLoading = false
    
    }
}
