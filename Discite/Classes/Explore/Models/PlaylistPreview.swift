//
//  PlaylistPreview.swift
//  Discite
//
//  Created by Jessie Li on 2/14/24.
//

import Foundation

struct PlaylistPreview: Codable, Identifiable {
    var id: UUID
    var title: String
    var playlistId: String
    var thumbnailURL: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case playlistId
        case thumbnailURL
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.playlistId = try container.decode(String.self, forKey: .playlistId)
        self.thumbnailURL = try container.decodeIfPresent(String.self, forKey: .thumbnailURL)
        
        self.id = UUID()
    }
}
