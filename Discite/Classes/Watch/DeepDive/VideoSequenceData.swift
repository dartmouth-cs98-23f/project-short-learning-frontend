//
//  VideoSequenceData.swift
//  Discite
//
//  Created by Jessie Li on 11/2/23.
//

import Foundation

struct VideoSequenceData: Decodable {
    var message: String
    var videos: [PlaylistData]
    var views: [Int]
    var likes: [Int]
    var dislikes: [Int]
    
    struct PlaylistData: Identifiable, Decodable {
        var id: String
        var title: String
        var description: String
        var uploadDate: Date
        var uploader: String
        var tags: [String]
        var duration: Int
        var thumbnailURL: String
        var clips: [ClipData]
        
        struct ClipData: Identifiable, Decodable {
            var id: String
            var videoId: String
            var title: String
            var description: String
            var uploadDate: Date
            var uploader: String
            var tags: [String]
            var duration: Int
            var thumbnailURL: String
            var clipURL: String
            var views: [Int]
            var likes: [Int]
            var dislikes: [Int]
        }

    }
}
