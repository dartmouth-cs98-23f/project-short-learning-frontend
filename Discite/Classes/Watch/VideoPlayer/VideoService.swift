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
    
    static func loadPlaylists(topicId: String? = nil, numPlaylists: Int = 2) async throws -> [Playlist] {
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
    
    // MARK: Drafts
    
    static func fetchSequence(query: PlaylistQuery,
                              completion: @escaping (SequenceData) -> Void,
                              failure: @escaping (APIError) -> Void) {
        
        print("Fetching playlists...")
        let path = "/api/recommendations/playlist"
        let method: HTTPMethod = .get
        
        // let topic = URLQueryItem(name: "topic", value: query.topic)
        let topicId = URLQueryItem(name: "topicId", value: query.topicId)
        let numPlaylists = URLQueryItem(name: "numPlaylists", value: String(query.numPlaylists))
        
        APIRequest<EmptyRequest, SequenceData>.call(
            scheme: APIConfiguration.scheme,
            host: APIConfiguration.host,
            path: path,
            port: APIConfiguration.port,
            method: method,
            authorized: true,
            // queryItems: [topic, topicId, numPlaylists])
            queryItems: [topicId, numPlaylists]) { data in
                
                do {
                    print("Video Service received data from APIRequest, decoding.")
                    let decoder = CustomJSONDecoder.shared
                    let sequence = try decoder.decode(SequenceData.self, from: data)
                    completion(sequence)
                    
                } catch {
                    print(String(describing: error))
                }
                
            } failure: { error in
                failure(error)
            }
    }
}
