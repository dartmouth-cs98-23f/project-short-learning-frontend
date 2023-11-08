//
//  SequenceData.swift
//  Discite
//
//  Created by Jessie Li on 11/2/23.
//

import Foundation

struct SequenceData: Decodable {
    var currentClipIndex: [Int]
    var videos: [PlaylistData]
    var views: [Int]
    var likes: [Int]
    var dislikes: [Int]
    
    enum CodingKeys: String, CodingKey {
        case currentClipIndex
        case videos
        case views
        case likes
        case dislikes
    }
    
    struct PlaylistData: Decodable {
        var _id: String
        var title: String
        var description: String
        var uploadDate: Date
        var uploader: String
        var tags: [String]?
        var duration: Int
        var thumbnailURL: String
        var clips: [VideoData]
        
        struct VideoData: Decodable {
            var _id: String
            var videoId: String
            var title: String
            var description: String
            var uploadDate: Date
            var uploader: String
            var duration: Int
            var thumbnailURL: String
            var clipURL: String
            var views: [Int]
            var likes: [Int]
            var dislikes: [Int]
        }

    }
}
