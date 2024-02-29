//
//  SavedViewModel.swift
//  Discite
//
//  Created by Jessie Li on 2/19/24.
//

import Foundation

class SavedViewModel: ObservableObject {
    @Published var error: Error?
    @Published var savedPlaylists: [PlaylistPreview] = []
    @Published var savedTopics: [TopicTag] = []
    
    init() { }
    
    // GET saved playlists and topics
    @MainActor
    public func getSaved() async {
        error = nil
        
        do {
            print("GET saved")
            let response = try await APIRequest<EmptyRequest, SavedResponse>
                .mockRequest(method: .get,
                            authorized: true,
                            path: "/api/saved")
            
            savedPlaylists = response.savedPlaylists
            savedTopics = response.savedTopics
            
        } catch {
            print("Error in SavedViewModel.getSaved: \(error)")
            self.error = error
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
    var savedPlaylists: [PlaylistPreview]
    var savedTopics: [TopicTag]
}
