//
//  AppEnvironment.swift
//  Discite
//
//  Created by Jessie Li on 3/19/24.
//
//  From:
//      Alexey Naumov
//      AppEnvironment.swift, CountriesSwiftUI
//      09.11.2019
//      https://github.com/nalexn/clean-architecture-swiftui/blob/mvvm/CountriesSwiftUI/System/AppEnvironment.swift

import UIKit
import Combine

struct AppEnvironment {
    let container: DIContainer
}

extension AppEnvironment {
    
    static func bootstrap() -> AppEnvironment {
        let appState = AppState()
    
        let session = configuredURLSession()
        let webRepositories = configuredWebRepositories(session: session)
        let services = configuredServices(appState: appState, webRepositories: webRepositories)
        let diContainer = DIContainer(appState: appState, services: services)
    
        return AppEnvironment(container: diContainer)
    }
    
    private static func configuredURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }
    
    private static func configuredWebRepositories(session: URLSession) -> DIContainer.WebRepositories {
        let exploreWebRepository = RealExploreWebRepository(
            session: session,
            baseURL: "https://api")
        return .init(exploreRepository: exploreWebRepository)
    }
    
    
    private static func configuredServices(appState: AppState,
                                           webRepositories: DIContainer.WebRepositories
    ) -> DIContainer.Services {
        
        let exploreService = RealExploreService2(
            webRepository: webRepositories.exploreRepository,
            appState: appState)
        
        return .init(exploreService: exploreService)
    }
}

extension DIContainer {
    struct WebRepositories {
        let exploreRepository: ExploreWebRepository
    }
}
