//
//  SignupViewModel.swift
//  Discite
//
//  Created by Colton Sankey on 10/25/23.
//

import Foundation

class SignupViewModel: ObservableObject {

    @Published var firstname: String = ""
    @Published var lastname: String = ""
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    @Published var error: APIError?
    
    func signup() {
        if password == confirmPassword {
            AuthenticationService.SignupService(
                parameters: SignupRequest(
                    username: username,
                    email: email,
                    firstname: firstname,
                    lastname: lastname,
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
        } else {
            print("Passwords do not match")
        }
    }
}
