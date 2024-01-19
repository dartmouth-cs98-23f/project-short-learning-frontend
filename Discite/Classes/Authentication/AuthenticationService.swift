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
    let token: String
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
    let birthDate: String
}

struct OnboardRequest: Encodable {
    let topics: [String]
}

struct OnboardResponse: Decodable {
    let playlists: [Playlist]
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
    
    static func onboard(parameters: OnboardRequest) async throws -> OnboardResponse {
        let response = try await APIRequest<OnboardRequest, OnboardResponse>
            .apiRequest(method: .post,
                        authorized: true,
                        path: "/api/user/technigala/onboard",
                        parameters: parameters)
        
        return response
    }
    
    static func mockLogin(parameters: LoginRequest) async throws -> AuthResponseData {
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
    
}
