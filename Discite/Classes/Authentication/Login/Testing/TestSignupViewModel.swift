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
    @Published var password: String = ""
    @Published var birthDate: String = "2000-10-10"

    @Published var error: APIError?
    @Published var internalError: String = ""
    @Published var isLoading: Bool = false
    
    func signup() {
        print("Signing up...")
        isLoading = true
        
//        AuthenticationService.SignupService(
//            parameters: SignupRequest(
//                username: username.lowercased(),
//                email: email,
//                firstName: firstname.lowercased(),
//                lastName: lastname.lowercased(),
//                password: password,
//                birthDate: birthDate)
//        ).call { response in
//                self.error = nil
//                
//                do {
//                    try Auth.shared.setToken(token: response.token)
//                    print("Set token successfully, logging in now: \(Auth.shared.loggedIn).")
//                } catch {
//                    print("Error: Unable to store token in keychain.")
//                }
//                
//                self.isLoading = false
//            
//        } failure: { error in
//            self.error = error
//            self.isLoading = false
//        }
        
        if !isLoading && !Auth.shared.loggedIn {
            self.error = APIError.requestFailed
        }
    }
}
