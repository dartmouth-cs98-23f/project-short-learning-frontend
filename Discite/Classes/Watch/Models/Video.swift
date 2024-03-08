//
//  Video.swift
//  Discite
//
//  Created by Jessie Li on 11/3/23.
//

import Foundation
import AVKit
import IGListKit

class Video: Decodable, Identifiable, ObservableObject {

    private(set) var id: UUID
    private(set) var videoId: String
    private(set) var playlistId: String
    private(set) var title: String
    private(set) var description: String
    private(set) var videoURL: String
    private(set) var videoLink: URL?
    
    // Reference to parent playlist
    var playlist: Playlist?

    @Published var state: ViewModelState = .loading
    public var isLiked: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case videoId = "_id"
        case playlistId = "videoId"
        case title
        case description
        case uploader
        case duration
        case thumbnailURL
        case videoURL = "clipURL"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = UUID()
        videoId = try container.decode(String.self, forKey: .videoId)
        playlistId = try container.decode(String.self, forKey: .playlistId)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        videoURL = try container.decode(String.self, forKey: .videoURL)
        videoLink = URL(string: videoURL)
    }
    
    // A sample video for previews.
    init() {
        id = UUID()
        videoId = "12345678"
        playlistId = "65d8fc1995f306b28d1b8870"
        title = "Video Title"
        description = "Sample video description here."
        videoURL = "https://player.vimeo.com/external/518476405.hd.mp4?s=df881ca929fbcf84aaf4040445a581a1d8e2137c&profile_id=173&oauth2_token_id=57447761"
        videoLink = URL(string: videoURL)
    }
    
    @MainActor
    func postUnderstanding(understand: Bool) async {
        do {
            _ = try await VideoService.postUnderstanding(videoId: videoId, understand: understand)
            
        } catch {
            self.state = .error(error: error)
            print("Error in Video.postUnderstanding: \(error)")
        }
    }
    
    @MainActor
    func postTimestamp(timestamp: Double) async {
        do {
            _ = try await VideoService.postTimestamp(
                playlistId: playlistId,
                videoId: videoId,
                timestamp: timestamp
            )
            
        } catch {
            self.state = .error(error: error)
            print("Error in Video.postTimestamp: \(error)")
        }
    }
}

extension Video: ListDiffable {
    public func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
        
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if object === self {
            return true
        }
        
        if let object = object as? Playlist {
            return id == object.id
        }
        
        return false
    }
}
