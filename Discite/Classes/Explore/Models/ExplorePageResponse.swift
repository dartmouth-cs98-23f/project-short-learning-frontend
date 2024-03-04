//
//  ExplorePageResponse.swift
//  Discite
//
//  Created by Jessie Li on 3/4/24.
//

import Foundation

struct ExplorePageResponse: Decodable {
    let topicVideos: [TopicVideo]
    let roleVideos: [RoleVideo]
    let page: Int
}

struct RoleVideo: Identifiable, Decodable {
    let id: UUID
    let role: String
    let videos: [PlaylistPreview]
    
    enum CodingKeys: String, CodingKey {
        case role, videos
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.role = try container.decode(String.self, forKey: .role)
        self.videos = try container.decode([PlaylistPreview].self, forKey: .videos)
        
        self.id = UUID()
    }
}

struct TopicVideo: Identifiable, Decodable {
    let id: UUID
    let topic: String
    let videos: [PlaylistPreview]
    
    enum CodingKeys: String, CodingKey {
        case topic, videos
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.topic = try container.decode(String.self, forKey: .topic)
        self.videos = try container.decode([PlaylistPreview].self, forKey: .videos)
        
        self.id = UUID()
    }
}
