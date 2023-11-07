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
    @Published var date: Date = Date.now
    @Published var birthdate: String = ""


    @Published var error: APIError?
    @Published var internalError: String = ""
    
    func signup() {
        self.internalError = ""
        if password == confirmPassword {
            self.birthdate = Date.toISO(date: self.date)
            print(username, firstname, lastname, password, email, birthdate)
            AuthenticationService.SignupService(
                parameters: SignupRequest(
                    username: username.lowercased(),
                    email: email,
                    firstname: firstname.lowercased(),
                    lastname: lastname.lowercased(),
                    password: password,
                    birthdate: birthdate
                )
            ).call { response in
                self.error = nil
                
                do {
                    print(self.birthdate)
                    try Auth.shared.setToken(token: response.token)
                    print("Signup successful")
                } catch {
                    print("Error: Unable to store token in keychain.")
                }
                
            } failure: { error in
                print(self.birthdate)
                self.error = error
            }
        } else {
            self.internalError = "Passwords do not match"
            print("Passwords do not match")
        }
    }
}

extension Date {
    static func toISO(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}