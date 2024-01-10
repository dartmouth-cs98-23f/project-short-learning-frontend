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

class VideoService {
    
    static func loadPlaylists(topicId: String? = nil, numPlaylists: Int = 2) async -> [Playlist] {
        await withTaskGroup(of: Optional<Playlist>.self) { group in

            // Fetch playlists asynchronously
            for _ in 1...numPlaylists {
                group.addTask {
                    do {
                        // let playlist = try await VideoService.fetchPlaylist(topicId: topicId)
                        let playlist = try await VideoService.mockFetchPlaylist(topicId: topicId)
                        return playlist
                    } catch {
                        print("Failed to load a playlist for sequence: \(error)")
                        return nil
                    }
                }
            }
            
            // Collect playlists into a list
            var playlists: [Playlist] = []
            for await playlist in group {
                if let playlist { playlists.append(playlist) }
            }
            
            return playlists
        }
    }
    
    static func fetchPlaylist(topicId: String? = nil) async throws -> Playlist {
        print("Fetching playlist...")
        let topicId = URLQueryItem(name: "topicId", value: topicId)
        let playlist = try await APIRequest<EmptyRequest, Playlist>
            .apiRequest(method: .get,
                        authorized: true,
                        path: "/api/recommendations/playlist",
                        queryItems: [topicId])
        
        return playlist
    }
    
    static func mockFetchPlaylist(topicId: String? = nil) async throws -> Playlist {
        print("TEST: Fetching playlist...")
        let playlist = try await APIRequest<EmptyRequest, Playlist>
            .mockAPIRequest(Playlist.self,
                            forResource: "sampleplaylist",
                            withExtension: "json")
        
        playlist.id = UUID().uuidString
        return playlist
    }

}
