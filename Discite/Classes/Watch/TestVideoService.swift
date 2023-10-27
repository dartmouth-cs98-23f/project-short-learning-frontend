//
//  TestVideoService.swift
//  Discite
//
//  Created by Jessie Li on 10/25/23.
//
//  Source:
//      https://github.com/stephdiep/VideoPlayerApp/blob/main/VideoFinder/VideoManager.swift

import Foundation

struct TestVideoRequest: Encodable {
    let usernameOrEmail: String
    let password: String
}

class TestVideoService: ObservableObject {
    
    @Published private(set) var videos: [Video] = []
    @Published var error: String?
    @Published var fetchedVideos: Bool = false
    
    let scheme: String  = "https"
    let host: String = "api.pexels.com"
    let path: String = "/videos/search?query=nature&per_page=10&orientation=portrait"
    let method: HTTPMethod = .get
    
    func fetchVideos() async {
            var components = URLComponents()
            components.scheme = scheme
            components.host = host
            components.path = path
            
            guard let url = components.url else {
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request.setValue("YOUR_API_KEY", forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard (response as? HTTPURLResponse)?.statusCode == 200 else { return }
                
                if let data = data {
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let decodedData = try? decoder.decode(TestVideoResponse.self, from: data)
                    
                    guard let decodedData = decodedData else {
                        self.error = "Error decoding JSON."
                        return
                    }
                    
                    self.videos = decodedData.videos
                    self.fetchedVideos = true
                    
                } else if error != nil {
                    self.error = "API request failed."
                
                }
            }
            
            task.resume()
        
    }
}

// From Pexels API
struct TestVideoResponse: Decodable {
    var page: Int
    var perPage: Int
    var totalResults: Int
    var url: String
    var videos: [Video]
    
}

struct Video: Identifiable, Decodable {
    var id: Int
    var image: String
    var duration: Int
    var user: User
    var videoFiles: [VideoFile]
    
    struct User: Identifiable, Decodable {
        var id: Int
        var name: String
        var url: String
    }
    
    struct VideoFile: Identifiable, Decodable {
        var id: Int
        var quality: String
        var fileType: String
        var link: String
    }
}
