//
//  ExploreService.swift
//  Discite
//
//  Created by Jessie Li on 11/8/23.
//  Updated by Jessie Li on 2/14/24.
//

import Foundation
import SwiftUI

struct ExploreService {
    static func getTopicRecommendations() async throws -> [TopicTag] {
        print("GET topic recommendations")
        
        let data = try await APIRequest<EmptyRequest, TopicRecommendations>
            .apiRequest(method: .get,
                         authorized: true,
                         path: "/api/topics/recommended")
                        // path: "/api/recommendations/topics")
        
        return data.recommendedTopics
    }
    
    static func getPlaylistRecommendations() async throws -> [PlaylistPreview] {
        print("GET playlist recommendations")
        
        let data = try await APIRequest<EmptyRequest, PlaylistRecommendations>
            .apiRequest(method: .get,
                         authorized: true,
                         path: "/api/playlists/recommended")
        
        return data.recommendedPlaylists
    }
    
    static func getAllTopics() async throws -> [TopicTag] {
        print("GET api/topics/all")
        
        let data = try await APIRequest<EmptyRequest, AllTopicsResponse>
            .apiRequest(method: .get,
                         authorized: true,
                         path: "/api/topics/all")
        
        return data.topics
    }
}

struct AllTopicsResponse: Codable {
    var topics: [TopicTag]
}

struct TopicRecommendations: Codable {
    var recommendedTopics: [TopicTag]
}

struct PlaylistRecommendations: Codable {
    var recommendedPlaylists: [PlaylistPreview]
}
