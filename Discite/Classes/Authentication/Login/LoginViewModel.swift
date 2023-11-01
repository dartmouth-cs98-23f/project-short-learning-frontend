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

    @Published var usernameOrEmail: String = ""
    @Published var password: String = ""

    @Published var error: APIError?
    
    func login() {
        AuthenticationService.LoginService(
            parameters: LoginRequest(
                usernameOrEmail: usernameOrEmail,
                password: password
            )
        ).call { response in
            self.error = nil
            
            do {
                try Auth.shared.setToken(token: response.token)
            } catch {
                print("Error: Unable to store token in keychain.")
            }
            
        } failure: { error in
            self.error = error
        }
    }
}
