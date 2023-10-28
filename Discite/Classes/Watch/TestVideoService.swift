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

struct TestVideoService {
    
    func fetchVideos(
        videoId: String,
        completion: @escaping (TestVideoResponse) -> Void,
        failure: @escaping (APIError) -> Void
    ) {
        
        let path: String = "/videos/videos/" + videoId
        let method: HTTPMethod = .get
        let headerFields: [String : String] = ["Authorization": VideoAPIConfiguration.shared.APIkey]
        
        APIRequest<TestVideoRequest, TestVideoResponse>.call(
            scheme: VideoAPIConfiguration.shared.scheme,
            host: VideoAPIConfiguration.shared.host,
            path: path,
            method: method,
            authorized: false,
            headerFields: headerFields) { data in
                
                do {
                    let response = try JSONDecoder().decode(TestVideoResponse.self, from: data)
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
struct TestVideoResponse: Decodable {
    var id: Int
    var url: Int
    var video_files: [VideoFile]
}

struct VideoFile: Identifiable, Decodable {
    var id: Int
    var quality: String
    var file_type: String
    var link: String
}
