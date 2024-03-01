//
//  Playlist.swift
//  Discite
//
//  Created by Jessie Li on 11/2/23.
//

import Foundation

enum PlaylistError: Error {
    case noNextVideo
    case emptyPlaylist
    case indexOutOfRange
    case savePlaylist
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
    @Published var isDisliked: Bool = false
    @Published var isSaved: Bool
    @Published var error: Error?

    var length: Int {
        return videos.count
    }
    
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
        currentIndex = 0
        isLoading = false
    }
    
    // MARK: Getters

    func currentVideo() -> Video? {
        if currentIndex >= 0 && currentIndex < videos.count {
            return videos[currentIndex]
        }
        
        return nil
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
    
    @MainActor
    func postSave() async {
        do {
            _ = try await VideoService.postSave(playlistId: playlistId)
       
        } catch {
            self.error = PlaylistError.savePlaylist
            print("Error in Playlist.postSave: \(error)")
        }
    }
    
    @MainActor
    func deleteSave() async {
        do {
            _ = try await VideoService.deleteSave(playlistId: playlistId)
       
        } catch {
            self.error = PlaylistError.savePlaylist
            print("Error in Playlist.deleteSave: \(error)")
        }
    }
    
    @MainActor
    func postLike() async {
        do {
            _ = try await VideoService.postLike(playlistId: playlistId)
       
        } catch {
            self.error = PlaylistError.savePlaylist
            print("Error in Playlist.postLike: \(error)")
        }
    }
    
    @MainActor
    func deleteLike() async {
        do {
            _ = try await VideoService.deleteLike(playlistId: playlistId)
       
        } catch {
            self.error = PlaylistError.savePlaylist
            print("Error in Playlist.deleteLike: \(error)")
        }
    }
    
    @MainActor
    func postDislike() async {
        do {
            _ = try await VideoService.postDislike(playlistId: playlistId)
       
        } catch {
            self.error = PlaylistError.savePlaylist
            print("Error in Playlist.postDislike: \(error)")
        }
    }
    
    @MainActor
    func deleteDislike() async {
        do {
            _ = try await VideoService.deleteDislike(playlistId: playlistId)
       
        } catch {
            self.error = PlaylistError.savePlaylist
            print("Error in Playlist.deleteDislike: \(error)")
        }
    }
}
