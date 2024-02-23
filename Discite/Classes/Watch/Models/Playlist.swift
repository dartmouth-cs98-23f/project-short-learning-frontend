//
//  Playlist.swift
//  Discite
//
//  Created by Jessie Li on 11/2/23.
//

import Foundation
import AVKit

enum PlaylistError: Error {
    case noNextVideo
    case emptyPlaylist
    case indexOutOfRange
    case savePlaylist
}

extension PlaylistError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noNextVideo:
            return NSLocalizedString("Error.PlaylistError.NoNextVideo", comment: "Playlist error")
        case .emptyPlaylist:
            return NSLocalizedString("Error.PlaylistError.EmptyPlaylist", comment: "Playlist error")
        case .indexOutOfRange:
            return NSLocalizedString("Error.PlaylistError.IndexOutOfRange", comment: "Playlist error")
        case.savePlaylist:
            return NSLocalizedString("Error.PlaylistError.UnableToSavePlaylist", comment: "Playlist error")
        }
    }
}

class Playlist: Decodable, Identifiable, ObservableObject {
    
    var id: UUID
    var playlistId: String
    var sequenceIndex: Int
    var videos: [Video]
    
    private(set) var title: String
    private(set) var description: String
    private(set) var topics: [TopicTag]
    private(set) var thumbnailURL: String
    private(set) var authorUsername: String = "johndoe"
    private(set) var youtubeId: String?
    
    @Published private(set) var currentIndex: Int
    @Published var isLoading: Bool
    @Published var isLiked: Bool = false
    @Published var isSaved: Bool
    @Published var error: Error?
    
    private(set) var playerItem: AVPlayerItem?
    
    enum CodingKeys: String, CodingKey {
        case playlistId = "_id"
        case title
        case description
        case isSaved
        case uploadDate
        case uploader
        case duration
        case thumbnailURL
        case youtubeId
        case topics
        case videos = "clips"
        case views
        case likes
        case dislikes
    }
    
    required init(from decoder: Decoder) throws {
        isLoading = true
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = UUID()
        playlistId = try container.decode(String.self, forKey: .playlistId)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        isSaved = try container.decode(Bool.self, forKey: .isSaved)
        topics = try container.decode([TopicTag].self, forKey: .topics)
        thumbnailURL = try container.decode(String.self, forKey: .thumbnailURL)
        youtubeId = try container.decodeIfPresent(String.self, forKey: .youtubeId)
        
        videos = try container.decode([Video].self, forKey: .videos)
        
        if videos.isEmpty {
            throw PlaylistError.emptyPlaylist
        }
        
        sequenceIndex = -1
        
        // Initialize player with first item
        currentIndex = 0
        playerItem = videos[0].getPlayerItem()
        isLoading = false
    }
    
    // MARK: Getters
    
    func onLastVideo() -> Bool {
        return currentIndex == videos.count - 1
    }
    
    func nextVideo() -> Video? {
        if currentIndex < videos.count - 1 {
            currentIndex += 1
            return videos[currentIndex]
        }
        
        return nil
    }
    
    func allVideos() -> [Video] {
        return videos
    }
    
    func currentVideo() -> Video? {
        if currentIndex >= 0 && currentIndex < videos.count {
            return videos[currentIndex]
        }
        
        return nil
    }
    
    func nextPlayerItem() -> AVPlayerItem? {
        return nextVideo()?.getPlayerItem()
    }
    
    func length() -> Int {
        return videos.count
    }
    
    // MARK: Setters
    
    func setCurrentIndex(index: Int) -> Bool {
        if index > videos.count - 1 {
            print("Error: Index out of range.")
            return false
        }
        
        currentIndex = index
        return true
    }
    
    func mockSave() async {
        do {
            _ = try await VideoService.mockSavePlaylist(
                parameters:
                    SavePlaylistRequest(playlistId: playlistId, saved: isSaved))
       
        } catch {
            self.error = PlaylistError.savePlaylist
            print("Error saving playlist: \(error)")
        }
    }
}
