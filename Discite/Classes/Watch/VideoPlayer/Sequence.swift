//
//  Sequence.swift
//  Discite
//
//  Created by Jessie Li on 11/2/23.
//
//  ViewModel for PlayerView, but owned by Navigator, because Sequence
//  stores information that Explore also needs.

import Foundation
import AVKit
import SwiftUI

class Sequence: ObservableObject {
    
    @Published private(set) var playerItem: AVPlayerItem?
    private(set) var player: AVPlayer = AVPlayer()
    
    private(set) var playlists: [Playlist] = []
    private(set) var topic: String?
    private(set) var topicId: String?
    private(set) var currentIndex: Int = 0 // Currently always 0, but could be useful later
    
    public func load(topicId: String? = nil, numPlaylists: Int = 2) async {
        playlists = await VideoService.loadPlaylists()
        print("Sequence loaded.")
            
        if playlists.isEmpty {
            print("Error: Empty sequence")
            return
        }
        
        playerItem = playlists[0].nextPlayerItem()
        player.replaceCurrentItem(with: playerItem)
        
        self.topicId = playlists[0].topicId
        self.topic = playlists[0].topic
        
    }
    
    public func length() -> Int {
        return playlists.count
    }
    
    public func currentPlaylist() -> Playlist? {
        return !playlists.isEmpty ? playlists[currentIndex] : nil
    }
    
    public func currentVideo() -> Video? {
        return currentPlaylist()?.currentVideo()
    }

    func next(swipeDirection: SwipeDirection) {
        
        if playlists.isEmpty {
            print("Playlists is empty, replacing queue")
            
            Task {
                await addPlaylist(topicId: topicId)
            }
        }
        
        // If swiped right, keep playing the current sequence
        else if swipeDirection == .right && playlists[currentIndex].onLastVideo() {
            // Dequeue current playlist
            dequeuePlaylists()
            
            // Add playlist to end of sequence
            Task {
                await addPlaylist(topicId: topicId)
            }
        }
        
        // Skip current playlist
        else if swipeDirection == .left {
            Task {
                await addPlaylist()
            }
        }
        
        // Make sure playlist is not empty
        if playlists.isEmpty {
            print("Error updating player: \(SequenceError.emptySequence.localizedDescription)")
            return
        }
        
        guard let nextVideo = playlists[currentIndex].nextVideo() else {
            print(PlaylistError.noNextVideo.localizedDescription)
            return
        }
        
        // Update next playerItem
        let playerItem = AVPlayerItem(url: URL(string: nextVideo.getURL())!)
        player.replaceCurrentItem(with: playerItem)
    }

    func currentVideo() -> AVPlayerItem? {
        if !playlists.isEmpty {
            let video = playlists[currentIndex].currentVideo()
            if let video { return AVPlayerItem(url: URL(string: (video.getURL()))!) }
        }
        return nil
    }
    
    func addPlaylist(topicId: String? = nil) async {
        do {
            let playlist = try await VideoService.fetchPlaylist(topicId: topicId)
            self.playlists.append(playlist)
        } catch {
            print("Failed to add playlist: \(error)")
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
