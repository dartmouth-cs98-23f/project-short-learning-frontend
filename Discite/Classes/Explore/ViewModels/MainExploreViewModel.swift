//
//  MainExploreViewModel.swift
//  Discite
//
//  Created by Jessie Li on 3/4/24.
//

import Foundation

class MainExploreViewModel: ObservableObject {
    @Published var topicVideos: [TopicVideo] = []
    @Published var roleVideos: [RoleVideo] = []
    @Published var state: ViewModelState = .loading
    private var task: Task<Void, Error>?
    
    private(set) var page: Int = 0
    
    init() {
        task = Task {
            let response = await getExplorePage()
        }
    }
    
    @MainActor
    public func getExplorePage() async -> ExplorePageResponse? {
        do {
            let response = try await ExploreService.getExplorePage(page: page + 1)
            self.page = page + 1
            return response
        } catch {
            print("Error in MainExploreViewModel.getExplorePage: \(error)")
            self.state = .error(error: error)
            return nil
        }
    }
    
    deinit {
        task?.cancel()
    }
}
