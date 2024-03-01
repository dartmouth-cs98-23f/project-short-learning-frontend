//
//  APIRequest.swift
//  Discite
//
//  Created by Jessie Li on 10/18/23.
//

import Foundation

typealias CompletionHandler = (Data) -> Void
typealias FailureHandler = (APIError) -> Void

struct EmptyRequest: Encodable {}
struct EmptyResponse: Decodable {}

enum HTTPMethod: String {
    case get
    case put
    case delete
    case post
}

enum APIError: Error {
    case invalidURL
    case invalidJSON
    case requestFailed
    case noInternet
    case unknownError
}

struct APIConfiguration {
    static let scheme: String = "http"
    // static let host: String = "18.215.28.176"
    // static let host: String = "localhost"
    static let host: String = "f88d6905-4ea0-47c3-b7e5-62341a73fe65.mock.pstmn.io"
    static let port: Int? = nil
    // static let port: Int? = 3000
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Error.APIError.InvalidURL", comment: "API error")
        case .invalidJSON:
            return NSLocalizedString("Error.APIError.InvalidJSON", comment: "API error")
        case .requestFailed:
            return NSLocalizedString("Error.APIError.RequestFailed", comment: "API error")
        case .noInternet:
            return NSLocalizedString("Error.APIError.NoInternet", comment: "API error")
        case .unknownError:
            return NSLocalizedString("Error.APIError.UnknownError", comment: "API error")
        }
    }
}

class APIRequest<Parameters: Encodable, Model: Decodable> {
    
    static func apiRequest(
        method: HTTPMethod,
        scheme: String = APIConfiguration.scheme,
        host: String = APIConfiguration.host,
        authorized: Bool,
        port: Int? = APIConfiguration.port,
        path: String,
        parameters: Parameters? = nil,
        queryItems: [URLQueryItem]? = nil,
        headers: [String: String]? = nil) async throws -> Model {
        
            if !NetworkMonitor.shared.isReachable {
                throw APIError.noInternet
            }
            
            // Construct URL
            var components = URLComponents()
            components.scheme = scheme
            components.host = host
            components.path = path
            components.port = port
            
            if queryItems != nil {
                components.queryItems = queryItems
            }
            
            guard let url = components.url else {
                throw APIError.invalidURL
            }
            
            // Construct the request: method, body, and headers
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            
            if headers != nil {
                for header in headers! {
                    request.addValue(header.value, forHTTPHeaderField: header.key)
                }
            } else {
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            if parameters != nil {
                request.httpBody = try? JSONEncoder().encode(parameters)
            }
            
            if authorized, let token = User.getToken() {
                request.addValue("\(token)", forHTTPHeaderField: "Authorization")
            }
            
            // Make request
            let (data, response) = try await URLSession.shared.data(for: request)
            
            let httpResponse = response as? HTTPURLResponse
            guard (200..<300).contains(httpResponse?.statusCode ?? 520) else {
                throw APIError.requestFailed
            }
            
            let decoded = try CustomJSONDecoder.shared.decode(Model.self, from: data)
            return decoded
    }
    
    // Calls mock Postman server.
    static func mockRequest(
        method: HTTPMethod,
        authorized: Bool,
        path: String,
        parameters: Parameters? = nil,
        queryItems: [URLQueryItem]? = nil,
        headers: [String: String]? = nil) async throws -> Model {
            
            var mockHeaders = headers
            if parameters != nil && headers == nil {
                mockHeaders = [
                    "Content-Type": "application/json",
                    "x-mock-match-request-body": "true"
                ]
            }
            
            let response = try await apiRequest(
                method: method,
                scheme: "https",
                host: "f88d6905-4ea0-47c3-b7e5-62341a73fe65.mock.pstmn.io",
                authorized: authorized,
                port: nil,
                path: path,
                parameters: parameters,
                queryItems: queryItems,
                headers: mockHeaders)
        
            return response
    }
}
