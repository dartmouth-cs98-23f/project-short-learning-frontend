//
//  TestAuthenticationService.swift
//  Discite
//
//  Created by Jessie Li on 11/14/23.
//

import Foundation

struct TestLoginRequest {
    var username: String
}

class TestAuthenticationService {
    
    static func login(parameters: LoginRequest,
                      completion: @escaping (AuthResponseData) -> Void,
                      failure: @escaping (APIError) -> Void) {
        
        let path = "/api/auth/signin"
        let method: HTTPMethod = .post
        
        APIRequest<LoginRequest, AuthResponseData>.call(
            scheme: APIConfiguration.scheme,
            host: APIConfiguration.host,
            path: path,
            port: APIConfiguration.port,
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
