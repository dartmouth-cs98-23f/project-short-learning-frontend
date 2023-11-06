//
//  TestVideoService.swift
//  Discite
//
//  Created by Jessie Li on 10/25/23.
//
//  Source:
//      Pexels API: https://www.pexels.com/api/documentation/#videos-show
//      Example of fetching from Pexels: https://github.com/stephdiep/VideoPlayerApp/blob/main/VideoFinder/VideoManager.swift

import Foundation

struct TestVideoRequest: Encodable {
    
}

struct VideoAPIConfiguration {
    static let shared = VideoAPIConfiguration()
    
    let scheme: String = "https"
    let host: String = "api.pexels.com"
    let APIkey: String = "5GNjXyXuHegB03rbiBcXjsdiMaZABuNfmAdOpzsjdFkVtMfPim9AEZ59"
}

class TestVideoService: ObservableObject {
    
    static let shared: TestVideoService = TestVideoService()
    
    // Fetches hard-coded playlist data
    func fetchPlaylist(completion: @escaping (SequenceData.PlaylistData) -> Void,
                       failure: @escaping (APIError) -> Void) {
        
        print("Fetching playlist...")
        
        do {
            let playlistData = try TestVideoData.playlistData()
            completion(playlistData)
        } catch {
            failure(APIError.unknownError)
        }
    }
    
    // Fetches hard-coded video sequence data (multiple playlists)
    func fetchVideoSequence(completion: @escaping (SequenceData) -> Void,
                            failure: @escaping (APIError) -> Void) {
        
        print("Fetching video sequence...")
        
        do {
            let videoSequenceData = try TestVideoData.videoSequenceData()
            completion(videoSequenceData)
        } catch {
            failure(APIError.unknownError)
        }
    }
    
    // Fetches a specific video from Pexels API based on ID
    func fetchVideo(
        videoId: String,
        completion: @escaping (VideoData) -> Void,
        failure: @escaping (APIError) -> Void
    ) {
        
        let path: String = "/videos/videos/" + videoId
        let method: HTTPMethod = .get
        let headerFields: [String: String] = ["Authorization": VideoAPIConfiguration.shared.APIkey]
        
        APIRequest<TestVideoRequest, VideoData>.call(
            scheme: VideoAPIConfiguration.shared.scheme,
            host: VideoAPIConfiguration.shared.host,
            path: path,
            method: method,
            authorized: false,
            headerFields: headerFields) { data in
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let response = try decoder.decode(VideoData.self, from: data)
                    completion(response)

                } catch {
                    failure(.invalidJSON)
                }
                
            } failure: { error in
                failure(error)
            }
        
    }
}

// From Pexels API
struct VideoData: Identifiable, Decodable {
    var id: Int
    var videoFiles: [VideoFile]
    
    struct VideoFile: Identifiable, Decodable {
        var id: Int
        var quality: String
        var fileType: String
        var link: String
    }
}
