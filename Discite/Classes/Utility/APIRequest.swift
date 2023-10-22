//
//  APIRequest.swift
//  Discite
//
//  Created by Jessie Li on 10/18/23.
//
//  Source:
//      https://medium.com/mop-developers/build-your-first-swiftui-app-part-6-creating-the-api-helper-class-d73d589fc4b5

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
    case invalidJSON
    case requestFailed
    case noInternet
    case unknownError
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
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
    
    static func call(
        scheme: String,
        host: String,
        path: String,
        method: HTTPMethod,
        authorized: Bool,
        queryItems: [URLQueryItem]? = nil,
        parameters: Parameters? = nil,
        completion: @escaping CompletionHandler,
        failure: @escaping FailureHandler
    ) {
        
        if !NetworkMonitor.shared.isReachable {
            return failure(.noInternet)
        }
        
        // Construct the URL
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        
        if let queryItems = queryItems {
            components.queryItems = queryItems
        }
        
        guard let url = components.url else {
            return
        }
        
        // Construct the request: method, body, and headers
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("true", forHTTPHeaderField: "x-mock-match-request-body")
        
        if let parameters = parameters {
            request.httpBody = try? JSONEncoder().encode(parameters)
        }
        
        if authorized, let token = Auth.shared.getToken() {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Make the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                completion(data)
            } else if error != nil {
                failure(APIError.requestFailed)
            }
        }
        
        task.resume()
    }
}
