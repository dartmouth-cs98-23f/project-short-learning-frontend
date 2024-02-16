//
//  Topic.swift
//  Discite
//
//  Created by Jessie Li on 11/9/23.
//

import Foundation

struct Topic: Decodable, Identifiable {
    var id: UUID
    var topicId: String
    var topicName: String
    var description: String?
    var spiderGraphData: RolesResponse
    var playlistPreviews: [PlaylistPreview]
    
    enum CodingKeys: String, CodingKey {
        case topicId
        case topicName
        case description
        case roleDistribution
        case playlistPreviews
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.topicId = try container.decode(String.self, forKey: .topicId)
        self.topicName = try container.decode(String.self, forKey: .topicName)
        self.description = try container.decode(String.self, forKey: .description)
        self.spiderGraphData = try container.decode(RolesResponse.self, forKey: .roleDistribution)
        self.playlistPreviews = try container.decode([PlaylistPreview].self, forKey: .playlistPreviews)
        
        self.id = UUID()
    }
    
}
