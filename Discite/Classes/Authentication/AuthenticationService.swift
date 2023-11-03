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
    let userId: String
    let message: String
}

struct LoginRequest: Encodable {
    let usernameOrEmail: String
    let password: String
}

struct SignupRequest: Encodable {
    let username: String
    let email: String
    let firstname: String
    let lastname: String
    let password: String
}


class AuthConfig {
    static let shared = AuthConfig()
    
    let scheme: String = "https"
    let host: String = "f88d6905-4ea0-47c3-b7e5-62341a73fe65.mock.pstmn.io" // Mock server
    let port: Int? = nil
}

struct AuthenticationService {
    struct LoginService {
        
        let path = "/login"
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
        
        let path = "/signup"
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
}
