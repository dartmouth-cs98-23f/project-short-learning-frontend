//
//  RecommendationsData.swift
//  Discite
//
//  Created by Jessie Li on 11/8/23.
//

import Foundation

struct Recommendations: Decodable {
    
    var userId: String
    var topics: [Topic]
    var subtopics: [Topic]
    
    enum CodingKeys: String, CodingKey {
        case message
        case recommendations
    }
    
    enum RecommendationsKeys: String, CodingKey {
        case userId
        case topics = "topVideoRecommendations"
        case subtopics = "topTopicVideoRecommendations"
    }
    
    init(from decoder: Decoder) throws {
        print("Decoding container...")
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let recommendations = try container.nestedContainer(keyedBy: RecommendationsKeys.self, forKey: .recommendations)
        
        userId = try recommendations.decode(String.self, forKey: .userId)
        topics = try recommendations.decode([Topic].self, forKey: .topics)
        subtopics = try recommendations.decode([Topic].self, forKey: .subtopics)
    }
    
}

struct Topic: Decodable, Identifiable {
    var id: String
    var title: String
    var clipIndex: Int
    // var videos: [Playlist] = []
    var playlist: Playlist
    
    enum CodingKeys: String, CodingKey {
        // case sequenceData = "videoId"
        case playlist = "videoId"
        case clipIndex
        case title = "topicId"
        case id = "_id"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        clipIndex = try container.decode(Int.self, forKey: .clipIndex)
        
        // Translate sequence data into a list of Playlists
        // let sequence = try container.nestedContainer(keyedBy: SequenceData.CodingKeys.self, forKey: .sequenceData)
        // let playlists = try sequence.decode([SequenceData.PlaylistData].self, forKey: SequenceData.CodingKeys.videos)
        // let sequence = try container.decode([SequenceData.PlaylistData].self, forKey: .sequenceData)
        
//        for data in sequence {
//            let playlist = try Playlist(data: data)
//            videos.append(playlist)
//        }
        let playlistData = try container.decode(SequenceData.PlaylistData.self, forKey: .playlist)
        playlist = try Playlist(data: playlistData)
        
    }
}
