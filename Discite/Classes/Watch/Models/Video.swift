//
//  Video.swift
//  Discite
//
//  Created by Jessie Li on 11/3/23.
//

import Foundation
import AVKit

class Video: Decodable, Identifiable, ObservableObject {

    var id: UUID
    var videoId: String
    var playlistId: String
    var title: String
    var description: String
    var image: String
    var videoURL: String
    
    var isLiked: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case videoId = "_id"
        case playlistId = "videoId"
        case title
        case description
        case image
        case uploadDate
        case uploader
        case duration
        case thumbnailURL
        case videoURL = "clipURL"
        case views
        case likes
        case dislikes
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = UUID()
        videoId = try container.decode(String.self, forKey: .videoId)
        playlistId = try container.decode(String.self, forKey: .playlistId)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        image = try container.decode(String.self, forKey: .image)
        videoURL = try container.decode(String.self, forKey: .videoURL)
    }
    
    public func getURL() -> String {
        return videoURL
    }
    
    public func getPlayerItem() -> AVPlayerItem {
        return AVPlayerItem(url: URL(string: videoURL)!)
    }
    
}
