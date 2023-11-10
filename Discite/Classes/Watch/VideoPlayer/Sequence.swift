//
//  Sequence.swift
//  Discite
//
//  Created by Jessie Li on 11/2/23.
//

import Foundation
import AVKit
import SwiftUI

class Sequence: Decodable, ObservableObject {
    
    var playlists: [Playlist] = []
    var currentIndex: Int
    var topicId: String
    
    enum CodingKeys: String, CodingKey {
        case message
        case playlists
        case topicId
    }

    @Published private(set) var fetchSuccessful: Bool = false
    @Published private(set) var fetchError: APIError?
    
    // MARK: Initializers
    
    required init(from decoder: Decoder) throws {
        print("In Sequence, decoding playlists...")
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        playlists = try container.decode([Playlist].self, forKey: .playlists)
        topicId = try container.decode(String.self, forKey: .topicId)
        currentIndex = 0
    }
    
    // MARK: Public Getters
    
    public func length() -> Int {
        return playlists.count
    }
    
    public func allPlaylists() -> [Playlist] {
        return playlists
    }
    
    public func currentPlaylist() -> Playlist? {
        return !playlists.isEmpty ? playlists[currentIndex] : nil
    }
    
    // MARK: Public Setters
    
    public func setCurrentIndex(index: Int) -> Bool {
        if index > playlists.count - 1 {
            print("Error: Index out of range.")
            return false
        }
        
        currentIndex = index
        return true
    }
    
    // MARK: Player Management
    
    public func replaceQueueWithTopic(topicId: String) {
        // Fetch new sequence with topicName, placeholder for now
        let sequence = VideoService.fetchTestSequence(topicId: topicId)
        
        if sequence != nil {
            self.playlists = sequence!.allPlaylists()
            self.topicId = topicId
            self.currentIndex = 0
            
        } else {
            print("Error: Couldn't fetch sequence from topic \(topicId)")
        }
    }
    
    
    func nextVideo(swipeDirection: SwipeDirection, player: AVPlayer) {

        // If swiped right, keep playing the current sequence
        if swipeDirection == .right {
            
            // Queue could be empty if user skipped indices by clicking on a later video in Explore
            if playlists.isEmpty {
                // Fetch new sequence, with same topicId
                replaceQueueWithTopic(topicId: topicId)
                
            // If current playlist is on last video
            } else if playlists[currentIndex].onLastVideo() {
                
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
        
        guard let nextVideo = playlists[currentIndex].nextVideo() else {
            print(PlaylistError.noNextVideo.localizedDescription)
            return
        }
        
        // Update the player
        player.replaceCurrentItem(with: nextVideo.getPlayerItem())
        print("Updated player, sequence length is \(playlists.count).")
    }
    
    // MARK: Private Methods
    
    private func addPlaylist() {
        print("Adding new playlist...")
        
        // Synchronizes asynchronous behaviors
        // let dispatchGroup = DispatchGroup()
        
        let playlist = VideoService.fetchTestPlaylist(topicId: topicId)
        
        if playlist != nil {
            playlists.append(playlist!)
            print("New playlist added to queue.")
        } else {
            print("Error adding playlist.")
        }

    }
    
    private func dequeuePlaylist() {
        print("Dequeuing first playlist...")
        
        if playlists.isEmpty {
            print(PlaylistError.emptyPlaylist.localizedDescription)
            return
        }
        
        playlists.removeFirst()
    }

}
