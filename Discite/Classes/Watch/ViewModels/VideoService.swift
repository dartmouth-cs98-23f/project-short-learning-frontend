//
//  VideoService.swift
//  Discite
//
//  Created by Jessie Li on 10/25/23.
//

import Foundation
import AVFoundation

struct PlaylistQuery: Encodable {
    var topic: String?
    var topicId: String?
    var numPlaylists: Int
}

struct SequenceData: Decodable {
    var playlists: [Playlist]
}

struct UnderstandRequest: Encodable {
    var understand: Bool
}

struct VideoTimestampRequest: Encodable {
    var timestamp: Double
}

struct VectorizedRecommendationsResponse: Decodable {
    struct Results: Decodable {
        let userId: String
        let videos: [Playlist]
    }

    let results: Results
}

class VideoService {
    
    static func fetchSequence(playlistId: String? = nil) async throws -> [Playlist] {
        if let playlistId {
            print("GET sequence with playlistId \(playlistId)")
            let query = URLQueryItem(name: "firstPlaylistId", value: playlistId)
            
            let data = try await APIRequest<EmptyRequest, VectorizedRecommendationsResponse>
                .apiRequest(method: .get,
                        authorized: true,
                        path: "/api/recommendations/vectorized",
                        queryItems: [query])
            
            return data.results.videos
            
        } else {
            print("GET /api/recommendations/vectorized")
            let data = try await APIRequest<EmptyRequest, VectorizedRecommendationsResponse>
                .apiRequest(method: .get,
                            authorized: true,
                            path: "/api/recommendations/vectorized")

            return data.results.videos
        }
    }
    
    static func postSave(playlistId: String) async throws {
        print("POST api/save/playlists/\(playlistId)")
        let path = "/api/save/playlists/\(playlistId)"
        
        _ = try await APIRequest<EmptyRequest, EmptyResponse>
            .apiRequest(method: .post,
                         authorized: true,
                         path: path)
    }
    
    static func deleteSave(playlistId: String) async throws {
        print("DELETE api/save/playlists/\(playlistId)")
        let path = "/api/save/playlists/\(playlistId)"
        
        _ = try await APIRequest<EmptyRequest, EmptyResponse>
            .apiRequest(method: .delete,
                         authorized: true,
                         path: path)
    }
    
    static func postLike(playlistId: String) async throws {
        print("POST api/like/playlists/\(playlistId)")
        let path = "/api/like/playlists/\(playlistId)"
        
        _ = try await APIRequest<EmptyRequest, EmptyResponse>
            .apiRequest(method: .post,
                         authorized: true,
                         path: path)
    }
    
    static func deleteLike(playlistId: String) async throws {
        print("DELETE api/like/playlists/\(playlistId)")
        let path = "/api/like/playlists/\(playlistId)"
        
        _ = try await APIRequest<EmptyRequest, EmptyResponse>
            .apiRequest(method: .delete,
                         authorized: true,
                         path: path)
    }
    
    static func postDislike(playlistId: String) async throws {
        print("POST api/dislike/playlists/\(playlistId)")
        let path = "/api/dislike/playlists/\(playlistId)"
        
        _ = try await APIRequest<EmptyRequest, EmptyResponse>
            .apiRequest(method: .post,
                         authorized: true,
                         path: path)
    }
    
    static func deleteDislike(playlistId: String) async throws {
        print("DELETE api/dislike/playlists/\(playlistId)")
        let path = "/api/dislike/playlists/\(playlistId)"
        
        _ = try await APIRequest<EmptyRequest, EmptyResponse>
            .apiRequest(method: .delete,
                         authorized: true,
                         path: path)
    }
    
    static func postUnderstanding(videoId: String, understand: Bool) async throws {
        print("POST api/videos/\(videoId)/understand")
        let path = "/api/videos/\(videoId)/understand"
        
        let parameters = UnderstandRequest(understand: understand)
        
        _ = try await APIRequest<UnderstandRequest, EmptyResponse>
            .apiRequest(method: .post,
                         authorized: true,
                         path: path,
                         parameters: parameters)
    }
    
    static func postTimestamp(videoId: String, timestamp: Double) async throws {
        print("POST api/videos/\(videoId)/timestamp")
        let path = "/api/videos/\(videoId)/timestamp"
        
        let parameters = VideoTimestampRequest(timestamp: timestamp)
        
        _ = try await APIRequest<VideoTimestampRequest, EmptyResponse>
            .apiRequest(method: .post,
                         authorized: true,
                         path: path,
                         parameters: parameters)
    }
    
    static func getPlaylistSummary(playlistId: String) async throws -> PlaylistInferenceSummary {
        print("GET api/videos/\(playlistId)/summary")
        let path = "/api/videos/\(playlistId)/summary"
        
        let response = try await APIRequest<EmptyRequest, PlaylistInferenceSummary>
            .apiRequest(method: .get,
                         authorized: true,
                         path: path)
        
        return response
    }
}
