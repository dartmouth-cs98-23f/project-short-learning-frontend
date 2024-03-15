//
//  AuthenticationService.swift
//  Discite
//
//  Created by Jessie Li on 10/14/23.
//
//  Source:
//      https://medium.com/mop-developers/build-your-first-swiftui-app-part-3-create-the-login-screen-334d90ef1763
//      https://medium.com/theleanprogrammer/api-call-in-swift-part-2-completion-error-handling-88075bf0210d

import Foundation

struct LoginResponse: Codable {
    let token: String
    let user: AuthResponseData

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.token = try container.decode(String.self, forKey: .token)
        self.user = try container.decode(AuthResponseData.self, forKey: .user)
    }
}

struct AuthResponseData: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let email: String
    let birthDate: String?
    let profilePicture: String?
    let onBoardingStatus: Bool

    init(username: String,
         firstName: String,
         lastName: String,
         email: String,
         birthDate: String? = nil,
         profilePicture: String? = nil,
         onBoardingStatus: Bool = false
    ) {
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.birthDate = birthDate
        self.profilePicture = profilePicture
        self.onBoardingStatus = onBoardingStatus
    }
}

struct SignUpResponseData: Decodable {
    // let userId: String
    let token: String
    // let message: String
}

struct LoginRequest: Encodable {
    let email: String
    let password: String
}

struct SignupRequest: Encodable {
    let username: String
    let email: String
    let firstName: String
    let lastName: String
    let password: String
}

struct GoogleLoginRequest: Codable {
    var idToken: String
}

struct AuthenticationService {

    static func login(parameters: LoginRequest) async throws -> LoginResponse {
        let response = try await APIRequest<LoginRequest, LoginResponse>
            .apiRequest(method: .post,
                        authorized: true,
                        path: "/api/auth/signin",
                        parameters: parameters)

        return response
    }

    static func signup(parameters: SignupRequest) async throws -> SignUpResponseData {
        let response = try await APIRequest<SignupRequest, SignUpResponseData>
            .apiRequest(method: .post,
                        authorized: false,
                        path: "/api/auth/signup",
                        parameters: parameters)

        return response
    }

}
