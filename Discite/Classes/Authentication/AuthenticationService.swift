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

struct LoginResponse: Decodable {
    let data: LoginResponseData
}

struct LoginResponseData: Decodable {
    let token: String
    let userId: String
    let message: String
}

struct LoginRequest: Encodable {
    let usernameOrEmail: String
    let password: String
}

class AuthConfig {
    static let shared = AuthConfig()
    
    let scheme: String = "https"
    let host: String = "f88d6905-4ea0-47c3-b7e5-62341a73fe65.mock.pstmn.io" // Mock server
}

struct AuthenticationService {

    let path = "/login"
    let method: HTTPMethod = .post
    var parameters: LoginRequest
        
    func call(
        completion: @escaping (LoginResponse) -> Void,
        failure: @escaping (APIError) -> Void
    ) {
        APIRequest<LoginRequest, LoginResponse>.call(
            scheme: AuthConfig.shared.scheme,
            host: AuthConfig.shared.host,
            path: path,
            method: method,
            authorized: false,
            parameters: parameters) { data in
                
                do {
                    let response = try JSONDecoder().decode(LoginResponse.self, from: data)
                    completion(response)
                } catch {
                    failure(.invalidJSON)
                }
                
            } failure: { error in
                failure(error)
            }
    }
}
