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

struct VideoRequest: Encodable {
    
}

struct VideoAPIConfiguration {
    static let shared = VideoAPIConfiguration()
    
    let scheme: String = "https"
    let host: String = "api.pexels.com"
    let APIkey: String = "5GNjXyXuHegB03rbiBcXjsdiMaZABuNfmAdOpzsjdFkVtMfPim9AEZ59"
}

class VideoService: ObservableObject {

    // Fetches hard-coded video sequence data (multiple playlists)
    static func fetchTestSequence(topicId: String? = nil, numPlaylists: Int? = 2) -> Sequence? {
        print("Fetching test playlists...")
        
        do {
            let sequence = try getSampleData(Sequence.self,
                                        forResource: "sampleplaylists",
                                        withExtension: "json")
            
            print("Got sample playlists, returning it as a sequence.")
            return sequence
            
        } catch {
            print("Couldn't get sample playlists: \(error)")
            return nil
        }
    }
    
    static func fetchTestPlaylist(topicId: String?) -> Playlist? {
        print("Fetching a single playlist...")
        
        let sequence = fetchTestSequence(topicId: topicId, numPlaylists: 1)
        return sequence?.currentPlaylist()
    }
    
}
