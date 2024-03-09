//
//  SavedViewModel.swift
//  Discite
//
//  Created by Jessie Li on 2/19/24.
//

import Foundation

class SavedViewModel: ObservableObject {
    @Published var state: ViewModelState = .loading
    @Published var savedPlaylists: [PlaylistPreview] = []
    @Published var savedTopics: [TopicTag] = []
    
    private var task: Task<Void, Error>? {
        willSet {
            if let currentTask = task {
                if currentTask.isCancelled { return }
                currentTask.cancel()
                // Setting a new task cancelling the current task
            }
        }
    }
    
    init() { 
        task = Task {
            await getSaved()
        }
    }
    
    // GET saved playlists and topics
    @MainActor
    public func getSaved() async {
        self.state = .loading
        
        do {
            print("GET /api/user/savedPlaylists")
            let response = try await APIRequest<EmptyRequest, SavedResponse>
                .apiRequest(method: .get,
                            authorized: true,
                            path: "/api/user/savedPlaylists")
            
            savedPlaylists = response.playlists ?? []
            savedTopics = response.topics ?? []
            self.state = .loaded
            
        } catch {
            print("Error in SavedViewModel.getSaved: \(error)")
            self.state = .error(error: error)
        }
    }
    
    // Filters unsaved topics out of savedTopics
    public func filterSavedTopics() {
        let filteredTopics = savedTopics.filter { topic in
            return topic.isSaved
        }
        
        savedTopics = filteredTopics
    }
}

struct SavedResponse: Codable {
    var playlists: [PlaylistPreview]?
    var topics: [TopicTag]?
}
