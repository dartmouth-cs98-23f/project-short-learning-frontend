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
        print("GET /api/topics/recommended")
        
        let data = try await APIRequest<EmptyRequest, TopicRecommendations>
            .apiRequest(method: .get,
                         authorized: true,
                         path: "/api/topics/recommended")
                        // path: "/api/recommendations/topics")
        
        return data.recommendedTopics
    }
    
    static func getPlaylistRecommendations() async throws -> [PlaylistPreview] {
        print("GET /api/playlists/recommended")
        
        let data = try await APIRequest<EmptyRequest, PlaylistRecommendations>
            .apiRequest(method: .get,
                         authorized: true,
                         path: "/api/playlists/recommended")
        
        return data.recommendedPlaylists
    }
    
    static func getAllTopics() async throws -> [TopicTag] {
        print("GET /api/explore/alltopics")
        
        let data = try await APIRequest<EmptyRequest, AllTopicsResponse>
            .apiRequest(method: .get,
                         authorized: true,
                         path: "/api/explore/alltopics")
        
        return data.topics
    }
    
    static func getExplorePage(page: Int) async throws -> ExplorePageResponse {
        print("GET /api/explore/explorepage")
        let query = URLQueryItem(name: "page", value: "\(page)")
        
        let data = try await APIRequest<EmptyRequest, ExplorePageResponse>
            .apiRequest(method: .get,
                        authorized: true,
                        path: "/api/explore/explorepage",
                        queryItems: [query])
        
        return data
    }
    
    static func getExploreSearch(query: String) async throws -> ExploreSearchResponse {
        print("GET /api/explore/search")
        let query = URLQueryItem(name: "q", value: query)
        
        let data = try await APIRequest<EmptyRequest, ExploreSearchResponse>
            .apiRequest(method: .get,
                        authorized: true,
                        path: "/api/explore/search",
                        queryItems: [query])
        
        return data
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
