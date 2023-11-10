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

    @Published private(set) var fetchSuccessful: Bool = false
    @Published private(set) var fetchError: APIError?
    
    // MARK: Initializers
    
    init() { }
    
    init(playlists: [Playlist]) {
        self.playlists = playlists
    }
    
    // MARK: Getters
    
    func currentPlaylist() -> Playlist? {
        if !playlists.isEmpty {
            return playlists[0]
        }
        
        return nil
    }
    
    func length() -> Int {
        return playlists.count
    }
    
    // MARK: Player Management
    
    func addPlaylist() {
        print("Adding new playlist...")
        
        // Synchronizes asynchronous behaviors
        let dispatchGroup = DispatchGroup()
        
        VideoService.fetchPlaylist { playlistData in
            do {
                dispatchGroup.enter()
                let playlist = try Playlist(data: playlistData)
                self.playlists.append(playlist)
                dispatchGroup.leave()
                
                print("New playlist added to queue.")
                
            } catch {
                dispatchGroup.leave()
                print("Error adding playlist: \(error.localizedDescription)")
                
            }
            
        } failure: { error in
            print(error.localizedDescription)
            return
            
        }
    }
    
    func dequeuePlaylist() {
        print("Dequeuing first playlist...")
        
        if playlists.isEmpty {
            print(PlaylistError.emptyPlaylist.localizedDescription)
            return
        }
        
        playlists.removeFirst()
    }
    
    func nextVideo(swipeDirection: SwipeDirection, player: AVPlayer) {

        // If swiped right, keep playing the current sequence
        if swipeDirection == .right {
            
            // First fetch, populate sequence
            if playlists.isEmpty {
                print("Playlist is empty, fetch a sequence of playlists.")
                fetchSequence()
                
            // If current playlist is on last video
            } else if playlists[0].onLastVideo() {
                
                // Dequeue current playlist
                dequeuePlaylist()
                
                // Add playlist to end of sequence
                addPlaylist()
                
            }
        }
        
        // Skip current playlist
        else if swipeDirection == .left && !playlists.isEmpty {
                
            // Dequeue current video
            dequeuePlaylist()
                
            // Add playlist, but call with different parameters (TBD)
            addPlaylist()
        }
    
        // Make sure playlist is not empty
        if playlists.isEmpty {
            print("Error updating player: \(PlaylistError.emptyPlaylist.localizedDescription)")
            return
        }
        
        guard let nextVideo = playlists[0].nextVideo() else {
            print(PlaylistError.noNextVideo.localizedDescription)
            return
        }
        
        // Update the player
        player.replaceCurrentItem(with: nextVideo.playerItem)
        print("Updated player, sequence length is \(playlists.count).")
    }
    
    // MARK: Additional Methods

    // Fetches a sequence of playlists
    func fetchSequence() {
        print("Fetching sequence...")
        self.fetchError = nil
        self.fetchSuccessful = false
        
        var nextPlaylists: [Playlist] = []
        
        // Synchronizes asynchronous behaviors
        let dispatchGroup = DispatchGroup()
        
        // Mock fetch video sequence
        VideoService.fetchVideoSequence { videoSequenceData in
            print("Response received. Now adding playlists.")
            
            // Add each playlist to next sequence
            for playlist in videoSequenceData.videos {
                
                dispatchGroup.enter()
                
                do {
                    let newPlaylist = try Playlist(data: playlist)
                    nextPlaylists.append(newPlaylist)
                    dispatchGroup.leave()
                    print("Created playlist with \(newPlaylist.length()) videos.")
                } catch {
                    dispatchGroup.leave()
                    print("Error initializing playlist: \(error.localizedDescription)")
                }
    
            }
            
            // Replace current sequence with the new sequence
            if !nextPlaylists.isEmpty {
                self.playlists = nextPlaylists
                self.fetchSuccessful = true
                print("Fetch successful. Sequence loaded with \(self.playlists.count) playlists.")
            }
            
        } failure: { error in
            print(error.localizedDescription)
            return
        }
    }

}
