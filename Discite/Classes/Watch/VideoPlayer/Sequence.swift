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
    var currentIndex: Int // Currently always 0, but could be useful later
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
    
    // MARK: Player Management
    
    public func skipToPlaylist(index: Int, player: AVPlayer) {
        
        if index > playlists.count - 1 {
            print("Error: Index out of range.")
            return
        }
        
        // Fill in the back of the queue
        let numSkipped = index - currentIndex
        addPlaylists(numPlaylists: numSkipped)
        
        guard let nextVideo = playlists[index].nextVideo() else {
            print(PlaylistError.noNextVideo.localizedDescription)
            return
        }
        
        // Update the player
        player.replaceCurrentItem(with: nextVideo.getPlayerItem())
        print("Updated player, skipped to playlist at index \(currentIndex).")
        
        // Dequeue skipped playlists
        dequeuePlaylists(numPlaylists: index)
        
        // currentIndex should still be 0
    }
    
    public func replaceQueueWithTopic(topicId: String) {
        
        let currentCount = playlists.count
        
        // Replace current queue with an equal number of playlists
        addPlaylists(topicId: topicId, numPlaylists: playlists.count)
        dequeuePlaylists(numPlaylists: currentCount)
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
                dequeuePlaylists()
                
                // Add playlist to end of sequence
                addPlaylists()
                
            }
        }
        
        // Skip current playlist
        else if swipeDirection == .left && !playlists.isEmpty {
                
            // Dequeue current video
            dequeuePlaylists()
                
            // Add playlist, but call with different parameters (TBD)
            addPlaylists()
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
    
    private func addPlaylists(topicId: String? = nil, numPlaylists: Int = 1) {
        print("Adding new playlist(s)...")
        
        if numPlaylists == 1 {
            let playlist = VideoService.fetchTestPlaylist(topicId: topicId)
            
            if playlist != nil {
                playlists.append(playlist!)
                print("New playlist added to queue.")
            } else {
                print("Error adding playlist.")
            }
            
            return
        }
        
        let sequence = VideoService.fetchTestSequence(topicId: topicId, numPlaylists: numPlaylists)
            
        if sequence != nil {
            self.playlists += sequence!.allPlaylists()
            self.topicId = topicId ?? self.topicId
            
        } else {
            print("Error: Couldn't fetch sequence from specified topic.")
        }
    }

    private func dequeuePlaylists(numPlaylists: Int = 1) {
        print("Dequeuing first playlist...")
        
        if numPlaylists > playlists.count {
            print("Error: \(PlaylistError.emptyPlaylist.localizedDescription)")
            return
        }
        
        playlists.removeFirst(numPlaylists)
    }

}
