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
    
}
