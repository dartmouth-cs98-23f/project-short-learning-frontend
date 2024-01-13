//
//  SignupViewModel.swift
//  Discite
//
//  Created by Colton Sankey on 10/25/23.
//

import Foundation

class SignupViewModel: ObservableObject {

    @Published var firstname: String = "John"
    @Published var lastname: String = "Doe"
    @Published var username: String = "johndoe"
    @Published var email: String = "johndoe@email.com"
    @Published var password: String = "abc123"
    @Published var confirmPassword: String = ""
    @Published var date: Date = Date.now
    @Published var birthDate: String =  "2000-10-10"

    @Published var error: Error?
    @Published var internalError: String = ""
    @Published var isLoading = false
    
    func signup() async {
        
        isLoading = true
        
        do {
            let response = try await AuthenticationService.mockSignup(
                parameters: SignupRequest(
                    username: username.lowercased(),
                    email: email,
                    firstName: firstname.lowercased(),
                    lastName: lastname.lowercased(),
                    password: password,
                    birthDate: birthDate))
            
            try Auth.shared.setToken(token: response.token)
            
        } catch {
            print("Signup failed: \(error)")
            self.error = error
        }
        
        isLoading = false
    }
    
//    func signup() {
//        self.internalError = ""
//        if password == confirmPassword {
//            self.birthDate = Date.toStr(date: self.date)
//            AuthenticationService.SignupService(
//                parameters: SignupRequest(
//                    username: username.lowercased(),
//                    email: email,
//                    firstName: firstname.lowercased(),
//                    lastName: lastname.lowercased(),
//                    password: password,
//                    birthDate: birthDate
//                )
//            ).call { response in
//                self.error = nil
//                
//                do {
//                    try Auth.shared.setToken(token: response.token)
//                } catch {
//                    print("Error: Unable to store token in keychain.")
//                }
//                
//            } failure: { error in
//                self.error = error
//            }
//        } else {
//            self.internalError = "Passwords do not match"
//            print("Passwords do not match")
//        }
//    }
}

extension Date {
    static func toStr(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
