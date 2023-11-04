//
//  Sequence.swift
//  Discite
//
//  Created by Jessie Li on 11/2/23.
//

import Foundation
import AVKit
import SwiftUI

class Sequence: ObservableObject {
    
    var playlists: [Playlist] = []
    var currentIndex = 0
    
    private var videoService: TestVideoService = TestVideoService.shared
    @Published private(set) var fetchSuccessful: Bool = false
    @Published private(set) var fetchError: APIError?
    
    // MARK: Initializers
    
    init() {
        fetchNextSequence()
    }
    
    init(playlists: [Playlist]) {
        self.playlists = playlists
    }
    
    // MARK: Getters
    
    func onLastPlaylist() -> Bool {
        return currentIndex == playlists.count - 1
    }
    
    func currentPlaylist() -> Playlist {
        return playlists[currentIndex]
    }
    
    func length() -> Int {
        return playlists.count
    }
    
    // MARK: Player Management
    
    func nextVideo(swipeDirection: SwipeDirection, player: AVPlayer) {
        
        // If swiped right, keep playing the current sequence
        if swipeDirection == .right {
            
            // If end of sequence (last playlist, last video)
            if onLastPlaylist() && playlists[currentIndex].onLastVideo() {
                fetchNextSequence()
            
            // If not last playlist, but current playlist is on last video
            } else if playlists[currentIndex].onLastVideo() {
                currentIndex += 1
            
            // If not last video in current playlist
            } else {
                
            }
        }
        
        // Fetch next sequence, with new parameters
        else if swipeDirection == .left {
            
        }
    
        let currentPlaylist = playlists[currentIndex]
        
        // Get next video in current playlist
        guard let nextVideo = currentPlaylist.nextVideo() else {
            print(PlaylistError.noNextVideo.localizedDescription)
            return
        }
        
        // Update the player
        player.replaceCurrentItem(with: nextVideo.playerItem)
        player.play()
    }
    
    // MARK: Additional Methods

    // Fetches next sequence of playlists
    func fetchNextSequence() {
        self.fetchError = nil
        self.fetchSuccessful = false
        
        var nextPlaylists: [Playlist] = []
        
        // Synchronizes asynchronous behaviors
        let dispatchGroup = DispatchGroup()
        
        // Mock fetch video sequence
        videoService.fetchVideoSequence { videoSequenceData in
            
            // Add each playlist to next sequence
            for playlist in videoSequenceData.videos {
                
                dispatchGroup.enter()
                
                do {
                    let newPlaylist = try Playlist(data: playlist)
                    nextPlaylists.append(newPlaylist)
                    dispatchGroup.leave()
                } catch {
                    dispatchGroup.leave()
                    print("Error initializing playlist.")
                }
    
            }
            
            // Replace current sequence with the new sequence
            if !nextPlaylists.isEmpty {
                self.playlists = nextPlaylists
                self.fetchSuccessful = true
                self.currentIndex = 0
            }
            
        } failure: { error in
            dispatchGroup.leave()
            
            print(error.localizedDescription)
            return
        }
    }

}
