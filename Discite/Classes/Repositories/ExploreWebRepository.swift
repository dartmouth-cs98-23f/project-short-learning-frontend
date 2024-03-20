//
//  ExploreWebRepository.swift
//  Discite
//
//  Created by Jessie Li on 3/18/24.
//
//  Based on:
//      https://github.com/nalexn/clean-architecture-swiftui/blob/master/CountriesSwiftUI/Repositories/CountriesWebRepository.swift
//

import Foundation

//protocol CountriesWebRepository: WebRepository {
//    func loadCountries() -> AnyPublisher<[Country], Error>
//    func loadCountryDetails(country: Country) -> AnyPublisher<Country.Details.Intermediate, Error>
//}
//
//struct RealCountriesWebRepository: CountriesWebRepository {
//    
//    let session: URLSession
//    let baseURL: String
//    let bgQueue = DispatchQueue(label: "bg_parse_queue")
//    
//    init(session: URLSession, baseURL: String) {
//        self.session = session
//        self.baseURL = baseURL
//    }
//    
//    func loadCountries() -> AnyPublisher<[Country], Error> {
//        return call(endpoint: API.allCountries)
//    }
//
//    func loadCountryDetails(country: Country) -> AnyPublisher<Country.Details.Intermediate, Error> {
//        let request: AnyPublisher<[Country.Details.Intermediate], Error> = call(endpoint: API.countryDetails(country))
//        return request
//            .tryMap { array -> Country.Details.Intermediate in
//                guard let details = array.first
//                    else { throw APIError.unexpectedResponse }
//                return details
//            }
//            .eraseToAnyPublisher()
//    }
//}

protocol ExploreWebRepository: WebRepository {
    func getExplorePage(page: Int) async throws -> ExplorePageResponse
}

struct RealExploreWebRepository: ExploreWebRepository {
    let session: URLSession
    let baseURL: String
    
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func getExplorePage(page: Int) async throws -> ExplorePageResponse {
        return try await call(endpoint: API.explorepage(page: page))
    }
}
    

// MARK: - Endpoints

extension RealExploreWebRepository {
    enum API {
        case explorepage(page: Int)
    }
}

// Configure path, method, headers, body, and query items based on API request type
extension RealExploreWebRepository.API: APICall {

    var path: String {
        switch self {
        case .explorepage:
            return "/api/explore/explorepage"
        }
    }
    
    var method: String {
        switch self {
        case .explorepage:
            return "GET"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .explorepage(let page):
            let query = URLQueryItem(name: "page", value: "\(page)")
        }
    }
    
    var headers: [String: String]? {
        return ["Accept": "application/json"]
    }
    
    func body() throws -> Data? {
        return nil
    }
}

//extension RealCountriesWebRepository {
//    enum API {
//        case allCountries
//        case countryDetails(Country)
//    }
//}
//
//extension RealCountriesWebRepository.API: APICall {
//    var path: String {
//        switch self {
//        case .allCountries:
//            return "/all"
//        case let .countryDetails(country):
//            let encodedName = country.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//            return "/name/\(encodedName ?? country.name)"
//        }
//    }
//    var method: String {
//        switch self {
//        case .allCountries, .countryDetails:
//            return "GET"
//        }
//    }
//    var headers: [String: String]? {
//        return ["Accept": "application/json"]
//    }
//    func body() throws -> Data? {
//        return nil
//    }
//}
