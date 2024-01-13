//
//  LoginViewModel.swift
//  Discite
//
//  Created by Jessie Li on 10/14/23.
// 
//  Source:
//      https://medium.com/mop-developers/build-your-first-swiftui-app-part-3-create-the-login-screen-334d90ef1763

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
        
        //        AuthenticationService.LoginService(
        //            parameters: LoginRequest(
        //                email: usernameOrEmail,
        //                password: password
        //            )
        //        ).call { response in
        //            self.error = nil
        //            print("starting call")
        //            do {
        //                try Auth.shared.setToken(token: response.token)
        //                Auth.shared.onboarded = true
        //                print("Login successful, user already onboarded: \(Auth.shared.loggedIn)")
        //            } catch {
        //                print("Error: Unable to store token in keychain.")
        //            }
        //        } failure: { error in
        //            self.error = error
        //        }
        //    }
    }
}
