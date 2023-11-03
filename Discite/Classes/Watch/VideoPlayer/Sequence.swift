//
//  Sequence.swift
//  Discite
//
//  Created by Jessie Li on 11/2/23.
//

import Foundation
import AVKit

class Sequence: ObservableObject {
    
    // Player for the current video
    @Published var player: AVPlayer = AVPlayer()
    
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
    
    func getCurrentPlayer() -> AVPlayer {
        return player
    }
    
    func length() -> Int {
        return playlists.count
    }
    
    // MARK: Player Management
    
    func play() {
        self.player.play()
        addVideoEndedNotification(player: self.player)
    }
    
    func pause() {
        self.player.pause()
        
    }
    
    func removeVideoEndedNotification(player: AVPlayer) {
        NotificationCenter
            .default
            .removeObserver(self,
                            name: .AVPlayerItemDidPlayToEndTime,
                            object: self.player.currentItem)
    }
    
    func addVideoEndedNotification(player: AVPlayer) {
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(self.videoPlayBackFinished),
                         name: .AVPlayerItemDidPlayToEndTime,
                         object: self.player.currentItem)
    }
    
    @objc func videoPlayBackFinished(_ notification: Notification) {
        self.player.seek(to: .zero)
        self.player.play()
    }
    
    func nextVideo(swipeDirection: SwipeDirection) throws {
        removeVideoEndedNotification(player: player)
        
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
            throw PlaylistError.noNextVideo
        }
        
        // Update the player
        player.replaceCurrentItem(with: nextVideo.playerItem)
        play()
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
