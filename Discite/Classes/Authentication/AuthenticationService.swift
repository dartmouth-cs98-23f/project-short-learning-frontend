//
//  AuthenticationService.swift
//  Discite
//
//  Created by Jessie Li on 10/14/23.
//
//  Source:
//      https://medium.com/mop-developers/build-your-first-swiftui-app-part-3-create-the-login-screen-334d90ef1763

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

struct AuthenticationService {

    var parameters: LoginRequest

    func call(completion: @escaping (LoginResponse) -> Void) {
        let scheme: String = "https"
        let host: String = "f88d6905-4ea0-47c3-b7e5-62341a73fe65.mock.pstmn.io" // mock server
        let path = "/login"

        // Construct the URL
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        guard let url = components.url else {
            return
        }

        // Construct the request: method, body, and headers
        var request = URLRequest(url: url)
        request.httpMethod = "post"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("true", forHTTPHeaderField: "x-mock-match-request-body")

        do {
            request.httpBody = try JSONEncoder().encode(parameters)
        } catch {

        }

        // Make the request
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data, error == nil {
                do {
                    let response = try JSONDecoder().decode(LoginResponse.self, from: data)
                    completion(response)
                } catch {
                    // Error: Unable to decode response JSON
                }

            } else {
                // Error: API request failed
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
}
