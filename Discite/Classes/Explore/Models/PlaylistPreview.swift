//
//  PlaylistPreview.swift
//  Discite
//
//  Created by Jessie Li on 2/14/24.
//

import Foundation

struct PlaylistPreview: Codable, Identifiable, Hashable {
    var id: UUID
    var title: String
    var playlistId: String
    var description: String?
    var thumbnailURL: String?
    var isSaved: Bool = false

    enum CodingKeys: String, CodingKey {
        case title
        case playlistId = "_id"
        case description
        case thumbnailURL
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.playlistId = try container.decode(String.self, forKey: .playlistId)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.thumbnailURL = try container.decodeIfPresent(String.self, forKey: .thumbnailURL)

        self.id = UUID()
    }

    init() {
        self.id = UUID()
        self.title = "Playlist Title"
        self.playlistId = "playlistId"
        self.description = "Playlist description here, can span multiple lines."
        self.thumbnailURL = "https://images.pexels.com/photos/1714208/pexels-photo-1714208.jpeg"
    }

    init(playlist: Playlist) {
        self.id = playlist.id
        self.title = playlist.title
        self.playlistId = playlist.playlistId
        self.description = playlist.description
        self.thumbnailURL = playlist.thumbnailURL
    }
}
