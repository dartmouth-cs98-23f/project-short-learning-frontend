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
    static func mockGetTopicRecommendations() async throws -> [TopicTag] {
        print("TEST: Getting topic recommendations...")
        
        let data = try await APIRequest<EmptyRequest, TopicRecommendations>
            .mockRequest(method: .get,
                         authorized: false,
                         path: "/api/recommendedTopics")
        
        return data.recommendedTopics
    }
    
    static func mockGetPlaylistRecommendations() async throws -> [PlaylistPreview] {
        print("TEST: Getting playlist recommendations...")
        
        let data = try await APIRequest<EmptyRequest, PlaylistRecommendations>
            .mockRequest(method: .get,
                         authorized: false,
                         path: "/api/recommendedPlaylists")
        
        return data.recommendedPlaylists
    }
}

struct TopicRecommendations: Codable {
    var recommendedTopics: [TopicTag]
}

struct PlaylistRecommendations: Codable {
    var recommendedPlaylists: [PlaylistPreview]
}
