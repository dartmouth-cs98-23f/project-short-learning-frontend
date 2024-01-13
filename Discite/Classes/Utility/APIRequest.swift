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
    static let host: String = "18.215.28.176"
    // static let host: String = "localhost"
    static let port: Int? = 3000
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
            
            if authorized, let token = Auth.shared.getToken() {
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
    
    // Fetches a local resource. 
    static func mockAPIRequest(_ type: Model.Type,
                               forResource: String,
                               withExtension: String) async throws -> Model {
        
        let decoder = CustomJSONDecoder()
        
        // Find path to resource
        guard let path = Bundle.main.url(forResource: forResource, withExtension: withExtension) else {
            print("Couldn't locate local resource.")
            throw APIError.unknownError
        }
        
        do {
            guard let data = try? Data(contentsOf: path) else {
                print("Failed to load data from path URL.")
                throw APIError.unknownError
            }
            
            let result = try decoder.decode(type.self, from: data)
            return result

        } catch {
            print(String(describing: error))
            throw APIError.invalidJSON
        }
    }
    
    // Calls mock Postman server.
    static func mockRequest(
        method: HTTPMethod,
        authorized: Bool,
        path: String,
        parameters: Parameters? = nil,
        queryItems: [URLQueryItem]? = nil,
        headers: [String: String]? = nil) async throws -> Model {
            
        let response = try await apiRequest(method: method,
                   scheme: APIConfiguration.scheme,
                   host: "f88d6905-4ea0-47c3-b7e5-62341a73fe65.mock.pstmn.io",
                   authorized: authorized,
                   port: nil,
                   path: path,
                   parameters: parameters,
                   queryItems: queryItems,
                   headers: headers)
        
        return response
    }
    
    // MARK: Drafts
    
    static func call(
        scheme: String,
        host: String,
        path: String,
        port: Int? = nil,
        method: HTTPMethod,
        authorized: Bool,
        parameters: Encodable? = nil,
        queryItems: [URLQueryItem]? = nil,
        headerFields: [String: String]? = nil,
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
        components.port = port
        
        if let queryItems = queryItems {
            components.queryItems = queryItems
        }
        
        guard let url = components.url else {
            return
        }
        
        // Construct the request: method, body, and headers
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let headerFields = headerFields {
            for headerField in headerFields {
                request.addValue(headerField.value, forHTTPHeaderField: headerField.key)
            }
            
        } else {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            // request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        
        if let parameters = parameters {
            request.httpBody = try? JSONEncoder().encode(parameters)
        }
        
        if authorized, let token = Auth.shared.getToken() {
            // request.addValue("eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI2NTUzZDE2YjIzYWUxODQxYzFhYjI5M2IiLCJpYXQiOjE2OTk5OTE5MTU2OTh9.LUONbCbcrC_KOV0IHW1ldcjuwBdwWxxpGgN7qe6XCds", forHTTPHeaderField: "Authorization")
            request.addValue("\(token)", forHTTPHeaderField: "Authorization")
        }
        
        print("Request URL: \(url)")
        print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")
        
        // Make the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            let httpResponse = response as? HTTPURLResponse
            
            guard httpResponse?.statusCode == 200 else {
                print("Error: \(httpResponse?.statusCode ?? 520)")
                failure(APIError.requestFailed)
                return
            }
                        
            if let data = data {
                print("APIRequest received data, passing to a Service.")
                
                DispatchQueue.main.async {
                    completion(data)
                }
                
            } else if error != nil {
                print(String(describing: error))
                failure(APIError.requestFailed)
            }
        }
        
        task.resume()
    }
}
