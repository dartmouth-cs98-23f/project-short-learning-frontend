//
//  Video.swift
//  Discite
//
//  Created by Jessie Li on 11/3/23.
//

import Foundation
import AVKit

struct Video: Decodable, Identifiable {

    var id: String
    var playlistId: String
    var title: String
    var description: String
    var videoURL: String

    var playerItem: AVPlayerItem
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case playlistId = "videoId"
        case title
        case description
        case uploadDate
        case uploader
        case duration
        case thumbnailURL
        case videoURL = "clipURL"
        case views
        case likes
        case dislikes
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        playlistId = try container.decode(String.self, forKey: .playlistId)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        videoURL = try container.decode(String.self, forKey: .videoURL)
        
        playerItem = AVPlayerItem(url: URL(string: videoURL)!)
    }
    
    public func getPlayerItem() -> AVPlayerItem {
        return playerItem
    }
    
}
