//
//  Sequence.swift
//  Discite
//
//  Created by Jessie Li on 11/2/23.
//

import Foundation
import AVKit
import SwiftUI

enum SequenceError: Error {
    case emptySequence
    case indexOutOfRange
}

extension SequenceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .emptySequence:
            return NSLocalizedString("Error.SequenceError.EmptySequence", comment: "Sequence error")
        case .indexOutOfRange:
            return NSLocalizedString("Error.SequenceError.IndexOutOfRange", comment: "Sequence error")
        }
    }
}

class Sequence: Decodable, ObservableObject {
    
    var playlists: [Playlist] = []
    var currentIndex: Int // Currently always 0, but could be useful later
    var topicId: String
    
    enum CodingKeys: String, CodingKey {
        case message
        case playlists
        case topicId
    }

    // MARK: Initializers
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        playlists = try container.decode([Playlist].self, forKey: .playlists)
        topicId = try container.decode(String.self, forKey: .topicId)
        currentIndex = 0
        
        if playlists.isEmpty {
            throw SequenceError.emptySequence
        }
        
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
    
    public func skipToPlaylist(index: Int) {
        
        if index > playlists.count - 1 {
            print("Error: Index out of range.")
            return
        }
        
        if index <= 0 {
            return
        }
        
        // Fill in the back of the queue
        let numSkipped = index - currentIndex
        addPlaylists(numPlaylists: numSkipped)
        
        // Dequeue skipped playlists
        dequeuePlaylists(numPlaylists: index)
    
        // currentIndex should still be 0
    }
    
    public func replaceQueueWithTopic(topicId: String, numPlaylists: Int = 4) {
        
        // Fetches 4 by default if numPlaylists is not a positive integer
        let currentCount = numPlaylists > 0 ? numPlaylists : 4
        
        // Replace current queue with an equal number of playlists
        addPlaylists(topicId: topicId, numPlaylists: playlists.count)
        dequeuePlaylists(numPlaylists: currentCount)
    }
    
    func currentVideo() -> AVPlayerItem? {
        if !playlists.isEmpty {
            let video = playlists[currentIndex].currentVideo()
        
            print("Sequence returning new item for current video.")
            return AVPlayerItem(url: URL(string: video.getURL())!)
        }
        return nil
    }
    
    func nextVideo(swipeDirection: SwipeDirection) -> AVPlayerItem? {

        // If swiped right, keep playing the current sequence
        if swipeDirection == .right {
            
            // If queue is empty for whatever reason, fetch new sequence
            if playlists.isEmpty {
                print("Playlists is empty, replacing queue")
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
            print("Error updating player: \(SequenceError.emptySequence.localizedDescription)")
            return nil
        }
        
        guard let nextVideo = playlists[currentIndex].nextVideo() else {
            print(PlaylistError.noNextVideo.localizedDescription)
            return nil
        }
        
        // Update next playerItem
        return AVPlayerItem(url: URL(string: nextVideo.getURL())!)
    }
    
    // MARK: Private Methods
    
    private func addPlaylists(topicId: String? = nil, numPlaylists: Int = 1) {
        print("Adding \(numPlaylists) playlists...")

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
        print("Dequeuing \(numPlaylists) playlists...")
        
        if numPlaylists > playlists.count {
            print("Error: \(PlaylistError.emptyPlaylist.localizedDescription)")
            return
        }
        
        playlists.removeFirst(numPlaylists)
    }

}
