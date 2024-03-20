//
//  ExploreService.swift
//  Discite
//
//  Created by Jessie Li on 3/18/24.
//
//  Based on:
//       Alexey Naumov
//       CountriesService.swift, CountriesSwiftUI
//       23.10.2019
//       https://github.com/nalexn/clean-architecture-swiftui/blob/mvvm/CountriesSwiftUI/Services/CountriesService.swift
//

import Foundation
import SwiftUI

protocol ExploreService2 {
    func getExplorePage(page: Int) async throws -> [any GenericTopic]
}

struct RealExploreService2: ExploreService2 {
    
    let webRepository: ExploreWebRepository
    let appState: AppState
    
    init(webRepository: ExploreWebRepository, appState: AppState) {
        self.webRepository = webRepository
        self.appState = appState
    }
    
    func getExplorePage(page: Int) async throws -> [any GenericTopic]  {
        let explorePage = try await webRepository.getExplorePage(page: page)
        
        var videos: [any GenericTopic] = []
        videos.append(contentsOf: explorePage.topicVideos)
        videos.append(contentsOf: explorePage.roleVideos)
        
        return videos
        
//        let task = Task { () -> [any GenericTopic] in
//            let explorePage = try await webRepository.getExplorePage()
//            
//            var videos: [any GenericTopic] = []
//            videos.append(contentsOf: explorePage.topicVideos)
//            videos.append(contentsOf: explorePage.roleVideos)
//            return videos
//        }
//        
//        topicsAndRolesVideos.wrappedValue.setIsLoading(task: task)
//        let result = await task.result
//        
//        do {
//            let videos = try result.get()
//            topicsAndRolesVideos.wrappedValue = .loaded(videos)
//            
//        } catch {
//            print("Unknown error.")
//        }
        
//        do {
//            let explorePage = try await webRepository.getExplorePage()
//            topicsAndRolesVideos.wrappedValue = .loaded(explorePage)
//            
//            return explorePage as ExplorePageResponse
//            
//        } catch {
//            return nil
//        }
    }
}


//protocol CountriesService {
//    func refreshCountriesList() -> AnyPublisher<Void, Error>
//    func load(countries: LoadableSubject<LazyList<Country>>, search: String, locale: Locale)
//    func load(countryDetails: LoadableSubject<Country.Details>, country: Country)
//}
//
//struct RealCountriesService: CountriesService {
//    
//    let webRepository: CountriesWebRepository
//    let dbRepository: CountriesDBRepository
//    let appState: Store<AppState>
//    
//    init(webRepository: CountriesWebRepository, dbRepository: CountriesDBRepository, appState: Store<AppState>) {
//        self.webRepository = webRepository
//        self.dbRepository = dbRepository
//        self.appState = appState
//    }
//
//    func load(countries: LoadableSubject<LazyList<Country>>, search: String, locale: Locale) {
//        
//        let cancelBag = CancelBag()
//        countries.wrappedValue.setIsLoading(cancelBag: cancelBag)
//        
//        Just<Void>
//            .withErrorType(Error.self)
//            .flatMap { [dbRepository] _ -> AnyPublisher<Bool, Error> in
//                dbRepository.hasLoadedCountries()
//            }
//            .flatMap { hasLoaded -> AnyPublisher<Void, Error> in
//                if hasLoaded {
//                    return Just<Void>.withErrorType(Error.self)
//                } else {
//                    return self.refreshCountriesList()
//                }
//            }
//            .flatMap { [dbRepository] in
//                dbRepository.countries(search: search, locale: locale)
//            }
//            .sinkToLoadable { countries.wrappedValue = $0 }
//            .store(in: cancelBag)
//    }
//    
//    func refreshCountriesList() -> AnyPublisher<Void, Error> {
//        return webRepository
//            .loadCountries()
//            .ensureTimeSpan(requestHoldBackTimeInterval)
//            .flatMap { [dbRepository] in
//                dbRepository.store(countries: $0)
//            }
//            .eraseToAnyPublisher()
//    }
//
//    func load(countryDetails: LoadableSubject<Country.Details>, country: Country) {
//        
//        let cancelBag = CancelBag()
//        countryDetails.wrappedValue.setIsLoading(cancelBag: cancelBag)
//
//        dbRepository
//            .countryDetails(country: country)
//            .flatMap { details -> AnyPublisher<Country.Details?, Error> in
//                if details != nil {
//                    return Just<Country.Details?>.withErrorType(details, Error.self)
//                } else {
//                    return self.loadAndStoreCountryDetailsFromWeb(country: country)
//                }
//            }
//            .sinkToLoadable { countryDetails.wrappedValue = $0.unwrap() }
//            .store(in: cancelBag)
//    }
//    
//    private func loadAndStoreCountryDetailsFromWeb(country: Country) -> AnyPublisher<Country.Details?, Error> {
//        return webRepository
//            .loadCountryDetails(country: country)
//            .ensureTimeSpan(requestHoldBackTimeInterval)
//            .flatMap { [dbRepository] in
//                dbRepository.store(countryDetails: $0, for: country)
//            }
//            .eraseToAnyPublisher()
//    }
//    
//    private var requestHoldBackTimeInterval: TimeInterval {
//        return ProcessInfo.processInfo.isRunningTests ? 0 : 0.5
//    }
//}
//
//struct StubCountriesService: CountriesService {
//    
//    func refreshCountriesList() -> AnyPublisher<Void, Error> {
//        return Just<Void>.withErrorType(Error.self)
//    }
//    
//    func load(countries: LoadableSubject<LazyList<Country>>, search: String, locale: Locale) {
//    }
//    
//    func load(countryDetails: LoadableSubject<Country.Details>, country: Country) {
//    }
//}
//
struct StubExploreService: ExploreService2 {
    
    func getExplorePage(page: Int) async throws -> [any GenericTopic] {
        return []
    }
    
}
