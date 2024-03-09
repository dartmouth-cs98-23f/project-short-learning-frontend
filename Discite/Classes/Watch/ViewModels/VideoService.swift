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

struct SavePlaylistRequest: Encodable {
    var playlistId: String
    var saved: Bool
}

struct DeleteSavedPlaylistRequest: Encodable {
    var playlistId: String
}

struct VideoTimestampRequest: Encodable {
    var clipId: String
    var duration: Double
}

struct VectorizedRecommendationsResponse: Decodable {
    struct Results: Decodable {
        let userId: String
        let videos: [Playlist]
    }

    let results: Results
}

struct GetSavedPlaylistResponse: Decodable {
    let playlist: Playlist
    
    enum CodingKeys: CodingKey {
        case metadata
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let metadata = try container.decode(Playlist.PlaylistMetadata.self, forKey: .metadata)
        self.playlist = Playlist(metadata: metadata, isSaved: true)
    }
}

class VideoService {
    
    static func getSequence(playlistId: String? = nil) async throws -> [Playlist] {
        if let playlistId {
            print("GET /api/recommendations/vectorized with \(playlistId)")
            let query = URLQueryItem(name: "videoId", value: playlistId)
            
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
    
    static func mockGetSequence(playlistId: String? = nil) async throws -> [Playlist] {
        if let playlistId {
            print("GET /api/recommendations/vectorized with \(playlistId)")
            let query = URLQueryItem(name: "videoId", value: playlistId)
            
            let data = try await APIRequest<EmptyRequest, VectorizedRecommendationsResponse>
                .mockRequest(method: .get,
                        authorized: false,
                        path: "/api/recommendations/vectorized",
                        queryItems: [query])
            
            return data.results.videos
            
        } else {
            print("GET /api/recommendations/vectorized")
            let data = try await APIRequest<EmptyRequest, VectorizedRecommendationsResponse>
                .mockRequest(method: .get,
                            authorized: false,
                            path: "/api/recommendations/vectorized")

            return data.results.videos
        }
    }
    
    static func getSavedPlaylist(playlistId: String) async throws -> Playlist {
        print("GET /api/recommendations/vectorized with \(playlistId)")
        let path = "/api/videos/\(playlistId)"
        
        let response = try await APIRequest<EmptyRequest, GetSavedPlaylistResponse>
            .apiRequest(method: .get, authorized: true, path: path)
        
        return response.playlist
    }
    
    static func putSave(playlistId: String, saved: Bool) async throws {
        print("PUT api/user/savePlaylist: \(playlistId), with save \(saved)")
        let path = "/api/user/savePlaylist"
        
        let requestBody = SavePlaylistRequest(playlistId: playlistId, saved: saved)
        
        _ = try await APIRequest<SavePlaylistRequest, EmptyResponse>
            .apiRequest(method: .put,
                         authorized: true,
                         path: path,
                         parameters: requestBody)
    }
    
    static func deleteSave(playlistId: String) async throws {
        print("DELETE /api/user/savedPlaylists: \(playlistId)")
        let path = "/api/user/savedPlaylists"
        
        let requestBody = DeleteSavedPlaylistRequest(playlistId: playlistId)
        
        _ = try await APIRequest<DeleteSavedPlaylistRequest, EmptyResponse>
            .apiRequest(method: .delete,
                         authorized: true,
                         path: path,
                         parameters: requestBody)
    }
    
    static func postLike(playlistId: String) async throws {
        print("POST /api/videos/\(playlistId)/like")
        let path = "/api/videos/\(playlistId)/like"
        
        _ = try await APIRequest<EmptyRequest, EmptyResponse>
            .apiRequest(method: .post,
                         authorized: true,
                         path: path)
    }
    
    static func deleteLike(playlistId: String) async throws {
        print("DELETE /api/videos/\(playlistId)/like")
        let path = "/api/videos/\(playlistId)/like"
        
        _ = try await APIRequest<EmptyRequest, EmptyResponse>
            .apiRequest(method: .delete,
                         authorized: true,
                         path: path)
    }
    
    static func postDislike(playlistId: String) async throws {
        print("POST /api/videos/\(playlistId)/dislike")
        let path = "/api/videos/\(playlistId)/dislike"
        
        _ = try await APIRequest<EmptyRequest, EmptyResponse>
            .apiRequest(method: .post,
                         authorized: true,
                         path: path)
    }
    
    static func deleteDislike(playlistId: String) async throws {
        print("DELETE /api/videos/\(playlistId)/dislike")
        let path = "/api/videos/\(playlistId)/dislike"
        
        _ = try await APIRequest<EmptyRequest, EmptyResponse>
            .apiRequest(method: .delete,
                         authorized: true,
                         path: path)
    }
    
    static func postWatchHistory(playlistId: String, videoId: String, timestamp: Double) async throws {
        print("POST /api/watchhistory/\(playlistId) with timestamp \(timestamp)")
        let path = "/api/watchhistory/\(playlistId)"
        
        let parameters = VideoTimestampRequest(clipId: videoId, duration: timestamp)
        
        _ = try await APIRequest<VideoTimestampRequest, EmptyResponse>
            .apiRequest(method: .post,
                         authorized: true,
                         path: path,
                         parameters: parameters)
    }
    
    static func postTooEasy(playlistId: String) async throws {
        print("POST /api/videos/\(playlistId)/tooeasy")
        let path = "/api/videos/\(playlistId)/tooeasy"
        
        _ = try await APIRequest<EmptyRequest, EmptyResponse>
            .apiRequest(method: .post,
                         authorized: true,
                         path: path)
    }
    
    static func postTooHard(playlistId: String) async throws {
        print("POST /api/videos/\(playlistId)/toohard")
        let path = "/api/videos/\(playlistId)/toohard"
        
        _ = try await APIRequest<EmptyRequest, EmptyResponse>
            .apiRequest(method: .post,
                         authorized: true,
                         path: path)
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
