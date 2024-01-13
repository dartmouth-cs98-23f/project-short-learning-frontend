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
                        authorized: true,
                        path: "/api/auth/signin",
                        parameters: parameters)
        
        return response
    }
    
//    struct LoginService {
//        
//        let path = "/api/auth/signin"
//        let method: HTTPMethod = .post
//        var parameters: LoginRequest
//        
//        func call(
//            completion: @escaping (AuthResponseData) -> Void,
//            failure: @escaping (APIError) -> Void
//        ) {
//            APIRequest<LoginRequest, AuthResponseData>.call(
//                scheme: APIConfiguration.scheme,
//                host: APIConfiguration.host,
//                path: path,
//                port: APIConfiguration.port,
//                method: method,
//                authorized: false,
//                parameters: parameters) { data in
//                    
//                    do {
//                        let response = try JSONDecoder().decode(AuthResponseData.self, from: data)
//                        completion(response)
//                    } catch {
//                        failure(.invalidJSON)
//                    }
//                    
//                } failure: { error in
//                    failure(error)
//                }
//        }
//    }
    
//    struct SignupService {
//        
//        let path = "/api/auth/signup"
//        let method: HTTPMethod = .post
//        var parameters: SignupRequest
//        
//        func call(
//            completion: @escaping (AuthResponseData) -> Void,
//            failure: @escaping (APIError) -> Void
//        ) {
//            APIRequest<SignupRequest, AuthResponseData>.call(
//                scheme: APIConfiguration.scheme,
//                host: APIConfiguration.host,
//                path: path,
//                port: APIConfiguration.port,
//                method: method,
//                authorized: false,
//                parameters: parameters) { data in
//                    
//                    do {
//                        let response = try JSONDecoder().decode(AuthResponseData.self, from: data)
//                        completion(response)
//                    } catch {
//                        failure(.invalidJSON)
//                    }
//                    
//                } failure: { error in
//                    failure(error)
//                }
//        }
//    }
    
//    struct OnboardService {
//        let path = "/api/user/technigala/onboard"
//        let method: HTTPMethod = .post
//        var parameters: OnboardRequest
//        
//        func call(
//            completion: @escaping (OnboardResponse) throws -> Void,
//            failure: @escaping (APIError) -> Void
//        ) {
//            APIRequest<OnboardRequest, OnboardResponse>.call(
//                scheme: APIConfiguration.scheme,
//                host: APIConfiguration.host,
//                path: path,
//                port: APIConfiguration.port,
//                method: method,
//                authorized: true,
//                parameters: parameters
//                ) { data in
//                    do {
//                        let response = try JSONDecoder().decode(OnboardResponse.self, from: data)
//                        
//                        try completion(response)
//                        // Auth.shared.onboarded = true
//                    } catch {
//                        failure(.invalidJSON)
//                    }
//                    
//                } failure: { error in
//                    failure(error)
//                }
//        }
//    }
}
