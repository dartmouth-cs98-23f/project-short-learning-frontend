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

class Playlist: ObservableObject {
    
    var data: SequenceData.PlaylistData
    var videos: [Video]
    var currentIndex: Int
    
    init(data: SequenceData.PlaylistData) throws {
        self.data = data
        self.videos = []
        self.currentIndex = 0
        
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
        
        // Set current index back to 0
        currentIndex = 0
    }
    
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
}
