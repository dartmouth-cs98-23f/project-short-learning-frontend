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
}

extension PlaylistError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noNextVideo:
            return NSLocalizedString("Error.PlaylistError.NoNextVideo", comment: "Playlist error")
        case .emptyPlaylist:
            return NSLocalizedString("Error.PlaylistError.EmptyPlaylist", comment: "Playlist error")
        }
    }
}

class Playlist: ObservableObject {
    
    var data: SequenceData.PlaylistData
    var videos: [Video]
    var currentIndex: Int
    
    init(data: SequenceData.PlaylistData) throws {
        self.data = data
        self.videos = []
        self.currentIndex = -1
        
        // Add each clip (video) to this playlist's queue
        for videoClip in data.clips {
            let playerItem = AVPlayerItem(url: URL(string: videoClip.clipURL)!)
            let video = Video(index: currentIndex, data: videoClip, playerItem: playerItem)
            
            videos.append(video)
            currentIndex += 1
        }
        
        if videos.isEmpty {
            throw PlaylistError.emptyPlaylist
        }
        
        // Set current index back to -1 (not yet started)
        currentIndex = -1
    }
    
    // MARK: Getters
    
    func onLastVideo() -> Bool {
        return currentIndex >= videos.count - 1
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
    
    func currentVideo() -> Video {
        return videos[currentIndex]
    }
    
    func getCurrentIndex() -> Int {
        return currentIndex
    }
    
    func getData() -> SequenceData.PlaylistData {
        return data
    }
    
    func length() -> Int {
        return videos.count
    }
    
    // MARK: Setters
    
    func setCurrentIndex(index: Int) {
        currentIndex = index
    }
}
