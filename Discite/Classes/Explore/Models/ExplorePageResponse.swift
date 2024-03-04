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
    // let role: String
    let videos: [PlaylistPreview]
    
    enum CodingKeys: String, CodingKey {
        case role, videos
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // self.role = try container.decode(String.self, forKey: .role)
        self.title = try container.decode(String.self, forKey: .role)
        self.videos = try container.decode([PlaylistPreview].self, forKey: .videos)
        
        self.id = UUID()
    }
}

struct TopicVideo: Identifiable, Decodable, GenericTopic {
    let id: UUID
    let title: String
    // let topic: String
    let videos: [PlaylistPreview]
    
    enum CodingKeys: String, CodingKey {
        case topic, videos
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // self.topic = try container.decode(String.self, forKey: .topic)
        self.title = try container.decode(String.self, forKey: .topic)
        self.videos = try container.decode([PlaylistPreview].self, forKey: .videos)
        
        self.id = UUID()
    }
}

struct GenericTopicVideo: Identifiable, Decodable {
    let id: UUID
    private(set) var type: TopicType
    private(set) var title: String
    private(set) var videos: [PlaylistPreview]
    
    enum TopicType: String, CaseIterable {
        case role, topic
    }
    
    enum TopicVideoKeys: String, CodingKey {
        case topic, videos
    }
    
    enum RoleVideoKeys: String, CodingKey {
        case role, videos
    }
    
    init(from decoder: Decoder) throws {
        self.id = UUID()
        
        do {
            let container = try decoder.container(keyedBy: TopicVideoKeys.self)
            self.title = try container.decode(String.self, forKey: .topic)
            self.videos = try container.decode([PlaylistPreview].self, forKey: .videos)
            self.type = .topic
            return
    
        } catch { 
    
        }
        
        let container = try decoder.container(keyedBy: RoleVideoKeys.self)
        self.title = try container.decode(String.self, forKey: .role)
        self.videos = try container.decode([PlaylistPreview].self, forKey: .videos)
        self.type = .role
    }
 }

protocol GenericTopic: Identifiable, Decodable, Hashable {
    var id: UUID { get }
    var title: String { get }
    var videos: [PlaylistPreview] { get }
}
