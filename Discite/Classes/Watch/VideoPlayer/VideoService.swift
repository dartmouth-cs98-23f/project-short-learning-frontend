//
//  VideoService.swift
//  Discite
//
//  Created by Jessie Li on 10/25/23.
//
//  Source:
//      Pexels API: https://www.pexels.com/api/documentation/#videos-show
//      Example of fetching from Pexels: https://github.com/stephdiep/VideoPlayerApp/blob/main/VideoFinder/VideoManager.swift

import Foundation

struct PlaylistQuery: Encodable {
    var topic: String?
    var topicId: String?
    var numPlaylists: Int
}

class VideoService {
    
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
        
        let topicId = URLQueryItem(name: "topicId", value: topicId)
        let playlist = try await APIRequest<EmptyRequest, Playlist>
            .mockAPIRequest(Playlist.self,
                            forResource: "sampleplaylist",
                            withExtension: "json")
        
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
    
    // Fetches hard-coded video sequence data (multiple playlists)
    static func fetchTestSequence() -> Sequence? {
        print("Fetching test sequence...")
        
        do {
            let sequenceData = try getSampleData(SequenceData.self,
                                                forResource: "sampleplaylists",
                                                 withExtension: "json")
            
            let sequence = Sequence()
            sequence.topic = sequenceData.topic
            sequence.playlists = sequenceData.playlists
            return sequence
            
        } catch {
            print("Couldn't get sample playlists: \(error)")
            return nil
        }
    }
    
    static func fetchTestPlaylist(topicId: String?) -> Playlist? {
        print("Fetching a single playlist...")
        
        let sequenceData = fetchTestSequence()
        return sequenceData?.playlists[0]
    }
    
}
