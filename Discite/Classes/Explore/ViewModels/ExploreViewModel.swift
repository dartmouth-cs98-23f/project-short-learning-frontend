//
//  ExploreViewModel.swift
//  Discite
//
//  Created by Jessie Li on 2/14/24.
//

import Foundation

class ExploreViewModel: ObservableObject {
    
    @Published var topicRecommendations: [TopicTag] = []
    @Published var playlistRecommendations: [PlaylistPreview]?
    @Published var error: Error?
    
    init() { }
    
    func getTopicRecommendations() async {
        do {
            topicRecommendations = try await ExploreService.mockGetTopicRecommendations()
        } catch {
            self.error = error
            print("Error fetching topic recommendations: \(error)")
        }
    }
    
    func getPlaylistRecommendations() async {
        do {
            playlistRecommendations = try await ExploreService.mockGetPlaylistRecommendations()
        } catch {
            self.error = error
            print("Error fetching playlist recommendations: \(error)")
        }
    }
    
    // combine topics and recommendations
    func createSearchables() -> [Searchable] {
        var searchables: [Searchable] = []
        
        // add topic recommendations
        for topic in topicRecommendations {
            let searchable = Searchable(id: topic.id.uuidString, name: topic.topicName, type: .topic, topic: topic, playlist: nil)
            searchables.append(searchable)
        }
        
        // add playlist recommendations
        if let playlists = playlistRecommendations {
            for playlist in playlists {
                let searchable = Searchable(id: playlist.id.uuidString, name: playlist.title, type: .playlist, topic: nil, playlist: playlist)
                searchables.append(searchable)
            }
        }

        print("Searchables complete")
        
        return searchables
    }
    
}
