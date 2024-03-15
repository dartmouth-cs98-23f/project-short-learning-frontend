//
//  SignupViewModel.swift
//  Discite
//
//  Created by Colton Sankey on 10/25/23.
//

import Foundation

@MainActor
class SignupViewModel: ObservableObject {
    @Published var firstname: String = ""
    @Published var lastname: String = ""
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    @Published var error: Error?
    @Published var isLoading = false

    func signup(user: User) async {

        isLoading = true

        do {
            let response = try await AuthenticationService.signup(
                parameters: SignupRequest(
                    username: username.lowercased(),
                    email: email,
                    firstName: firstname,
                    lastName: lastname,
                    password: password))

            let userData = AuthResponseData(username: username,
                                            firstName: firstname,
                                            lastName: lastname,
                                            email: email)

            try user.configure(token: response.token, data: userData)
            print("Signed up.")

        } catch {
            print("SignupViewModel.signup failed: \(error)")
            self.error = error
        }

        isLoading = false
    }

}

extension Date {
    static func toStr(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
