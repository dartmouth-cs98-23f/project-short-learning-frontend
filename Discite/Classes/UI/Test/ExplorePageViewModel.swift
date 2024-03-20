//
//  ExplorePageViewModel.swift
//  Discite
//
//  Created by Jessie Li on 3/18/24.
//

import SwiftUI

// MARK: - Routing

extension ExplorePage {
//    struct Routing: Equatable {
//        var countryDetails: Country.Code?
//        var topicDetails:
//    }
}

// MARK: - Search State

extension ExplorePage {
    struct ExploreSearch {
        var searchText: String = ""
        var keyboardHeight: CGFloat = 0
    }
}

// MARK: - ViewModel

extension ExplorePage {
    
    class ViewModel: ObservableObject {
        
        // State
        @Published var countriesSearch = ExploreSearch()
        @Published var topicsAndRolesVideos: Loadable<[any GenericTopic]>
        
        // Miscellaneous
        let container: DIContainer
        private var page: Int
        private var task: Task<Void, Error>? {
            willSet {
                if let currentTask = task {
                    if currentTask.isCancelled { return }
                    currentTask.cancel()
                    // Setting a new task cancelling the current task
                }
            }
        }
        
        // MARK: - Lifecycle
        
        init(container: DIContainer, topicsAndRolesVideos: Loadable<[any GenericTopic]> = .notRequested) {
            self.container = container
            let appState = container.appState
            self.page = 0

            _topicsAndRolesVideos = .init(initialValue: topicsAndRolesVideos)
        }
        
        deinit {
            task?.cancel()
        }
        
        // MARK: - Side Effects
        
        @MainActor
        func getExplorePage() async {
            topicsAndRolesVideos.setIsLoading()
            
            do {
                topicsAndRolesVideos = .loaded(try await container.services.exploreService.getExplorePage(page: page))
                self.page = page + 1
                
            } catch {
                topicsAndRolesVideos = .failed(error)
            }
        }
        
    }
}
