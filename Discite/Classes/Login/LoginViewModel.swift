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

    func login() {
        AuthenticationService(
            parameters: LoginRequest(
                usernameOrEmail: usernameOrEmail,
                password: password
            )
        ).call { result in
            
            switch result {
            case .success(let response):
                do {
                    try Auth.shared.setToken(token: response.data.token)
                } catch {
                    print("Error: Unable to store token in keychain.")
                }
            
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
