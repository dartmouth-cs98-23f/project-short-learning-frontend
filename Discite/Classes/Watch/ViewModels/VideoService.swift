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

struct SavePlaylistRequest: Codable {
    var playlistId: String
    var saved: Bool
}

class VideoService {
    static func fetchSequence(playlistId: String? = nil) async throws -> [Playlist] {
        if let playlistId {
            print("GET sequence with playlistId \(playlistId)")
            let query = URLQueryItem(name: "firstPlaylistId", value: playlistId)
            
            let data = try await APIRequest<EmptyRequest, SequenceData>
                .apiRequest(method: .get,
                        authorized: true,
                        path: "/api/playlists/sequence",
                        queryItems: [query])
            
            return data.playlists
            
        } else {
            print("GET playlists/sequence")
            let data = try await APIRequest<EmptyRequest, SequenceData>
                .apiRequest(method: .get,
                             authorized: true,
                             path: "/api/playlists/sequence")

            return data.playlists
        }
    }
    
    static func savePlaylist(parameters: SavePlaylistRequest) async throws {
        print("POST api/save/playlists/\(parameters.playlistId)")
        let path = "api/save/playlists/\(parameters.playlistId)"
        
        _ = try await APIRequest<SavePlaylistRequest, EmptyResponse>
            .apiRequest(method: .post,
                         authorized: true,
                         path: path,
                         parameters: parameters)
    }
}
