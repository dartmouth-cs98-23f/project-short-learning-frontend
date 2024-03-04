//
//  MainExploreViewModel.swift
//  Discite
//
//  Created by Jessie Li on 3/4/24.
//

import Foundation

class MainExploreViewModel: ObservableObject {
    @Published var topicsAndRolesVideos: [any GenericTopic] = []
    @Published var state: ViewModelState = .loading
    private var task: Task<Void, Error>?
    
    private(set) var page: Int = 0
    
    init() { }
    
    public func loadNextExplorePage() {
        task = Task {
            let response = await getExplorePage()
            self.topicsAndRolesVideos.append(contentsOf: response?.topicVideos ?? [])
            self.topicsAndRolesVideos.append(contentsOf: response?.roleVideos ?? [])
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
