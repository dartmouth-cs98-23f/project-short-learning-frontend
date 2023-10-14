//
//  LoginViewModel.swift
//  Discite
//
//  Created by Jessie Li on 10/14/23.
//  Source:
//      https://medium.com/mop-developers/build-your-first-swiftui-app-part-3-create-the-login-screen-334d90ef1763

import Foundation

class LoginViewModel: ObservableObject {

    @Published var usernameOrEmail: String = ""
    @Published var password: String = ""
    @Published var showSuccess = false

    func login() {
        self.showSuccess = false

        LoginAction(
            parameters: LoginRequest(
                usernameOrEmail: usernameOrEmail,
                password: password
            )
        ).call { response in
            // Login successful
            print("JWT token:", response.data.token)
            self.showSuccess = true
        }
    }
}
