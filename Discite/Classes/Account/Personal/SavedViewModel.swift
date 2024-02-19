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
    public func mockGetSaved() async {
        error = nil
        
        do {
            print("TEST: GET saved")
            let response = try await APIRequest<EmptyRequest, SavedResponse>
                .mockRequest(method: .get,
                            authorized: false,
                            path: "/api/saved")
            
            savedPlaylists = response.savedPlaylists
            savedTopics = response.savedTopics
            
        } catch {
            print("Error in SavedViewModel.getSaved: \(error)")
            self.error = error
        }
    }
    
}

struct SavedResponse: Codable {
    var savedPlaylists: [PlaylistPreview]
    var savedTopics: [TopicTag]
}
