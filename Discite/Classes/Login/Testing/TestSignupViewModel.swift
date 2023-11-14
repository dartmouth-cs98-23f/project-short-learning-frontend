//
//  TestSignupViewModel.swift
//  Discite
//
//  Created by Jessie Li on 11/14/23.
//

import Foundation

class TestSignupViewModel: ObservableObject {

    @Published var firstname: String = "Doe"
    @Published var lastname: String = "John"
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = "asd"
    @Published var birthDate: String = "2000-10-10"

    @Published var error: APIError?
    @Published var internalError: String = ""
    
    func signup() {
        print("Signing up...")
        
        AuthenticationService.SignupService(
            parameters: SignupRequest(
                username: username.lowercased(),
                email: email,
                firstName: firstname.lowercased(),
                lastName: lastname.lowercased(),
                password: password,
                birthDate: birthDate)
        ).call { response in
                self.error = nil
                
                do {
                    try Auth.shared.setToken(token: response.token)
                    print("Set token successfully, logging in now: \(Auth.shared.loggedIn)")
                } catch {
                    print("Error: Unable to store token in keychain.")
                }
                
        } failure: { error in
            self.error = error
        }
        
        if !Auth.shared.loggedIn {
            self.error = APIError.requestFailed
        }
    }
}
