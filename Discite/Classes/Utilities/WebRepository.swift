//
//  WebRepository.swift
//  Discite
//
//  Created by Jessie Li on 3/18/24.
//
//  Adapted from:
//      https://github.com/nalexn/clean-architecture-swiftui/blob/mvvm/CountriesSwiftUI/Utilities/WebRepository.swift
//      Rewritten to use async/await (more readable) instead of Combine.
//

import Foundation

protocol WebRepository {
    var session: URLSession { get }
    var baseURL: String { get }
}

extension WebRepository {
    func call<Value>(endpoint: APICall, httpCodes: HTTPCodes = .success) async throws -> Value where Value: Decodable {
        let request = try endpoint.urlRequest(baseURL: baseURL)
        let (data, response) = try await session.data(for: request)
        
        // assert(!Thread.isMainThread)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError2.unexpectedResponse
        }
        
        guard httpCodes.contains(httpResponse.statusCode) else {
            throw APIError2.httpCode(httpResponse.statusCode)
        }
        
        return try JSONDecoder().decode(Value.self, from: data)
    }
    
//    func call<Value>(endpoint: APICall, httpCodes: HTTPCodes = .success) -> AnyPublisher<Value, Error>
//        where Value: Decodable {
//        do {
//            let request = try endpoint.urlRequest(baseURL: baseURL)
//            return session
//                .dataTaskPublisher(for: request)
//                .requestJSON(httpCodes: httpCodes)
//        } catch let error {
//            return Fail<Value, Error>(error: error).eraseToAnyPublisher()
//        }
//    }
}

//extension Publisher where Output == URLSession.DataTaskPublisher.Output {
//    func requestData(httpCodes: HTTPCodes = .success) -> AnyPublisher<Data, Error> {
//        return tryMap {
//                assert(!Thread.isMainThread)
//                guard let code = ($0.1 as? HTTPURLResponse)?.statusCode else {
//                    throw APIError.unexpectedResponse
//                }
//                guard httpCodes.contains(code) else {
//                    throw APIError.httpCode(code)
//                }
//                return $0.0
//            }
//            .extractUnderlyingError()
//            .eraseToAnyPublisher()
//    }
//}
//
//private extension Publisher where Output == URLSession.DataTaskPublisher.Output {
//    func requestJSON<Value>(httpCodes: HTTPCodes) -> AnyPublisher<Value, Error> where Value: Decodable {
//        return requestData(httpCodes: httpCodes)
//            .decode(type: Value.self, decoder: JSONDecoder())
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//    }
//}
