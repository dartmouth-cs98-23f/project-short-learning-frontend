//
//  ExploreSearchResponse.swift
//  Discite
//
//  Created by Jessie Li on 3/4/24.
//

import Foundation

struct TopicSearchResult: Decodable, Identifiable {
    let topic: String
    let score: Int
    let id: UUID
    
    enum CodingKeys: String, CodingKey {
        case topic, score
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.topic = try container.decode(String.self, forKey: .topic)
        self.score = try container.decode(Int.self, forKey: .score)
        self.id = UUID()
    }
}

struct ExploreSearchResponse: Decodable {
    let playlists: [PlaylistPreview]?
    let topics: [TopicSearchResult]?
    
    enum CodingKeys: String, CodingKey {
        case videos, topics
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.topics = try container.decode([TopicSearchResult].self, forKey: .topics)
        
        let playlists = try container.decode([Playlist].self, forKey: .videos)
        self.playlists = playlists.map { playlist in
            return PlaylistPreview(playlist: playlist)
        }
    }
}
