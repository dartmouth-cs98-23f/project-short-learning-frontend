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

class AuthConfig {
    static let shared = AuthConfig()
    
    let scheme: String = "http"
    let host: String = "localhost" // must be running backend on localhost:3000
    let port: Int? = 3000
}

struct AuthenticationService {
    struct LoginService {
        
        let path = "/api/auth/signin"
        let method: HTTPMethod = .post
        var parameters: LoginRequest
        
        func call(
            completion: @escaping (AuthResponseData) -> Void,
            failure: @escaping (APIError) -> Void
        ) {
            APIRequest<LoginRequest, AuthResponseData>.call(
                scheme: AuthConfig.shared.scheme,
                host: AuthConfig.shared.host,
                path: path,
                port: AuthConfig.shared.port,
                method: method,
                authorized: false,
                parameters: parameters) { data in
                    
                    do {
                        let response = try JSONDecoder().decode(AuthResponseData.self, from: data)
                        completion(response)
                    } catch {
                        failure(.invalidJSON)
                    }
                    
                } failure: { error in
                    failure(error)
                }
        }
    }
    
    struct SignupService {
        
        let path = "/api/auth/signup"
        let method: HTTPMethod = .post
        var parameters: SignupRequest
        
        func call(
            completion: @escaping (AuthResponseData) -> Void,
            failure: @escaping (APIError) -> Void
        ) {
            APIRequest<SignupRequest, AuthResponseData>.call(
                scheme: AuthConfig.shared.scheme,
                host: AuthConfig.shared.host,
                path: path,
                port: AuthConfig.shared.port,
                method: method,
                authorized: false,
                parameters: parameters) { data in
                    
                    do {
                        let response = try JSONDecoder().decode(AuthResponseData.self, from: data)
                        completion(response)
                    } catch {
                        failure(.invalidJSON)
                    }
                    
                } failure: { error in
                    failure(error)
                }
        }
    }
    
    struct OnboardService {
        let path = "/api/user/technigala/onboard"
        let method: HTTPMethod = .post
        var parameters: OnboardRequest
        
        func call(
            completion: @escaping (OnboardResponse) throws -> Void,
            failure: @escaping (APIError) -> Void
        ) {
            APIRequest<OnboardRequest, OnboardResponse>.call(
                scheme: AuthConfig.shared.scheme,
                host: AuthConfig.shared.host,
                path: path,
                port: AuthConfig.shared.port,
                method: method,
                authorized: true,
                parameters: parameters
                ) { data in
                    do {
                        let response = try JSONDecoder().decode(OnboardResponse.self, from: data)
                        
                        try completion(response)
                        Auth.shared.onboarded=true
                    } catch {
                        failure(.invalidJSON)
                    }
                    
                } failure: { error in
                    failure(error)
                }
        }
    }
}
