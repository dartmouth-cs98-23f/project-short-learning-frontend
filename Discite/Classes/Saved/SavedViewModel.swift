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
    
    public func reload() {
        self.state = .loading
        task = Task {
            await getSaved()
        }
    }
    
    public func filter() {
        filterSavedTopics()
        filterSavedPlaylists()
    }
    
    // Filters unsaved topics out of savedTopics
    private func filterSavedTopics() {
        let filteredTopics = savedTopics.filter { topic in
            return topic.isSaved
        }
        
        savedTopics = filteredTopics
    }
    
    private func filterSavedPlaylists() {
        let filteredPlaylists = savedPlaylists.filter { playlist in
            return playlist.isSaved
        }
        
        savedPlaylists = filteredPlaylists
    }
}

struct SavedResponse: Codable {
    var playlists: [PlaylistPreview]?
    var topics: [TopicTag]?
}
