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

struct AuthResponseData: Decodable {
    let userId: String
    let username: String
    let token: String
    let message: String
    let firstName: String
    let lastName: String
    let email: String
    let birthDate: String
    let profilePicture: String?
    let onBoardingStatus: Bool
}

struct SignUpResponseData: Decodable {
    let userId: String
    let token: String
    let message: String
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
    
    static func login(parameters: LoginRequest) async throws -> AuthResponseData {
        let response = try await APIRequest<LoginRequest, AuthResponseData>
            .apiRequest(method: .post,
                        authorized: true,
                        path: "/api/auth/signin",
                        parameters: parameters)
        
        return response
    }
    
    static func signup(parameters: SignupRequest) async throws -> AuthResponseData {
        let response = try await APIRequest<SignupRequest, AuthResponseData>
            .apiRequest(method: .post,
                        authorized: false,
                        path: "/api/auth/signup",
                        parameters: parameters)
        
        return response
    }
    
    static func mockLogin(parameters: LoginRequest) async throws -> AuthResponseData {
        print("TEST: api/auth/signin")
        let response = try await APIRequest<LoginRequest, AuthResponseData>
            .mockRequest(method: .post,
                        authorized: true,
                        path: "/api/auth/signin",
                        parameters: parameters)
        
        return response
    }
    
    static func mockSignup(parameters: SignupRequest) async throws -> AuthResponseData {
        let response = try await APIRequest<SignupRequest, AuthResponseData>
            .mockRequest(method: .post,
                        authorized: false,
                        path: "/api/auth/signup",
                        parameters: parameters)
        
        return response
    }
    
    // https://developers.google.com/identity/sign-in/ios/backend-auth
    static func mockGoogleLogin(idToken: String) async throws -> AuthResponseData {
        let authData = GoogleLoginRequest(idToken: idToken)
        
        let response = try await APIRequest<GoogleLoginRequest, AuthResponseData>
            .mockRequest(method: .post,
                        authorized: false,
                        path: "/api/auth/googleSignIn",
                        parameters: authData,
                        headers: [:])
        
        return response
    }
    
}
