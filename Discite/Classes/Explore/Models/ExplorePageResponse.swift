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

struct RoleVideo: Identifiable, Decodable, GenericTopic {
    let id: UUID
    let title: String
    let videos: [PlaylistPreview]
    
    enum CodingKeys: String, CodingKey {
        case role, videos
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .role)
        self.videos = try container.decode([PlaylistPreview].self, forKey: .videos)
        
        self.id = UUID()
    }
}

struct TopicVideo: Identifiable, Decodable, GenericTopic {
    let id: UUID
    let topicId: String
    let title: String
    let videos: [PlaylistPreview]
    
    enum CodingKeys: String, CodingKey {
        case topic, topicId, videos
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .topic)
        self.topicId = try container.decode(String.self, forKey: .topicId)
        self.videos = try container.decode([PlaylistPreview].self, forKey: .videos)
        
        self.id = UUID()
    }
}

protocol GenericTopic: Identifiable, Decodable, Hashable {
    var id: UUID { get }
    var title: String { get }
    var videos: [PlaylistPreview] { get }
}
