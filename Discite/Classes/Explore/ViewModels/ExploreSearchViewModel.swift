//
//  ExploreSearchViewModel.swift
//  Discite
//
//  Created by Jessie Li on 3/4/24.
//

import Foundation

@MainActor
class ExploreSearchViewModel: ObservableObject {
    static let shared = ExploreSearchViewModel()

    @Published var state: ViewModelState = .loaded

    private(set) var resultPlaylists: [PlaylistPreview]?
    private(set) var resultTopics: [TopicSearchResult]?
    private(set) var resultUsers: [UserSearchResult]?

    private var task: Task<Void, Error>? {
        willSet {
            if let currentTask = task {
                if currentTask.isCancelled { return }
                currentTask.cancel()
                // Setting a new task cancelling the current task
            }
        }
    }

    private init() { }

    public func getSearchResults(query: String) {
        self.state = .loading

        task = Task {
            do {
                let response = try await ExploreService.getExploreSearch(query: query)

                self.resultTopics = response.topics
                self.resultPlaylists = response.playlists

                let userResponse = try await ExploreService.getExploreSearch(accountName: query)
                self.resultUsers = userResponse.users

                self.state = .loaded

            } catch {
                print("Error in ExploreSearchViewModel.getSearchResults: \(error)")
                self.state = .error(error: error)
            }
        }

    }

    deinit {
        task?.cancel()
    }
}
