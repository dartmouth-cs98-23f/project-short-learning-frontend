//
//  Playlist.swift
//  Discite
//
//  Created by Jessie Li on 11/2/23.
//

import Foundation
import IGListKit

enum PlaylistError: Error {
    case noNextVideo
    case emptyPlaylist
    case indexOutOfRange
    case savePlaylist
    case likePlaylist
    case dislikePlaylist
}

class Playlist: Decodable, Identifiable, ObservableObject {
    
    var id: UUID
    var playlistId: String
    var sequenceIndex: Int
    var videos: [Video]
    
    private(set) var title: String
    private(set) var description: String?
    private(set) var thumbnailURL: String?
    private(set) var authorUsername: String = "johndoe"
    private(set) var youtubeURL: String?
    private(set) var inferenceTopics: [String]
    private(set) var inferenceComplexities: [Double]
    
    @Published private(set) var currentIndex: Int
    @Published var state: ViewModelState = .loading
    @Published var isLiked: Bool = false
    @Published var isDisliked: Bool = false
    @Published var isSaved: Bool

    var length: Int {
        return videos.count
    }
    
    enum CodingKeys: String, CodingKey {
        case playlistId = "videoId"
        case topics
        case score
        case metadata
    }
    
    struct PlaylistMetadata: Decodable {
        var _id: String
        var title: String
        var description: String?
        var youtubeURL: String?
        var thumbnailURL: String?
        var clips: [Video]
        var inferenceComplexities: [Double]
        var inferenceTopics: [String]
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        playlistId = try container.decode(String.self, forKey: .playlistId)
        
        let metadata = try container.decode(PlaylistMetadata.self, forKey: .metadata)
        title = metadata.title
        description = metadata.description
        thumbnailURL = metadata.thumbnailURL
        videos = metadata.clips
        inferenceTopics = metadata.inferenceTopics
        inferenceComplexities = metadata.inferenceComplexities
        
        id = UUID()
        isSaved = false
        
        sequenceIndex = -1
        currentIndex = 0
        
        // Give videos a reference back to self
        for video in videos {
            video.playlist = self
        }
        
        if let youtubeLink = metadata.youtubeURL,
           let url = URL(string: youtubeLink),
           let path = url.host?.appending(url.path) {
            youtubeURL = path
        }

        state = .loaded
    }
    
    init() {
        self.id = UUID()
        self.playlistId = "65d8fc1995f306b28d1b8870"
        self.sequenceIndex = -1
        self.videos = []
        self.inferenceTopics = []
        self.inferenceComplexities = []
        
        self.title = "Playlist Title"
        self.description = "Playlist description here."
        
        self.currentIndex = -1
        self.isSaved = false
    }
    
    init(metadata: PlaylistMetadata, isSaved: Bool) {
        id = UUID()
        playlistId = metadata._id
        title = metadata.title
        description = metadata.description
        thumbnailURL = metadata.thumbnailURL
        videos = metadata.clips
        inferenceTopics = metadata.inferenceTopics
        inferenceComplexities = metadata.inferenceComplexities
        self.isSaved = isSaved
        
        sequenceIndex = -1
        currentIndex = 0
        
        // Give videos a reference back to self
        for video in videos {
            video.playlist = self
        }

        state = .loaded
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
    func putSave() async {
        do {
            _ = try await VideoService.putSave(playlistId: playlistId, saved: true)
            self.isSaved = true
       
        } catch {
            self.state = .error(error: PlaylistError.savePlaylist)
            print("Error in Playlist.putSave: \(error)")
        }
    }
    
    @MainActor
    func deleteSave() async {
        do {
            _ = try await VideoService.putSave(playlistId: playlistId, saved: false)
            self.isSaved = false
            
        } catch {
            self.state = .error(error: PlaylistError.savePlaylist)
            print("Error in Playlist.deleteSave: \(error)")
        }
    }
    
    @MainActor
    func postLike() async {
        do {
            _ = try await VideoService.postLike(playlistId: playlistId)
       
        } catch {
            self.state = .error(error: PlaylistError.likePlaylist)
            print("Error in Playlist.postLike: \(error)")
        }
    }
    
    @MainActor
    func deleteLike() async {
        do {
            _ = try await VideoService.deleteLike(playlistId: playlistId)
       
        } catch {
            self.state = .error(error: PlaylistError.likePlaylist)
            print("Error in Playlist.deleteLike: \(error)")
        }
    }
    
    @MainActor
    func postDislike() async {
        do {
            _ = try await VideoService.postDislike(playlistId: playlistId)
       
        } catch {
            self.state = .error(error: PlaylistError.dislikePlaylist)
            print("Error in Playlist.postDislike: \(error)")
        }
    }
    
    @MainActor
    func deleteDislike() async {
        do {
            _ = try await VideoService.deleteDislike(playlistId: playlistId)
       
        } catch {
            self.state = .error(error: PlaylistError.dislikePlaylist)
            print("Error in Playlist.deleteDislike: \(error)")
        }
    }
}

extension Playlist: ListDiffable {
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
