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

struct SequenceData: Decodable {
    var playlists: [Playlist] = []
    var topicId: String?
    var topic: String?
    
    enum CodingKeys: String, CodingKey {
        case playlists
        case topicId
        case topic
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        playlists = try container.decode([Playlist].self, forKey: .playlists)
        topicId = try container.decode(String.self, forKey: .topicId)
        topic = try container.decode(String.self, forKey: .topic)
        
        if playlists.isEmpty {
            throw SequenceError.emptySequence
        }
    }
}

class Sequence: ObservableObject {
    
    @Published var player: AVPlayer = AVPlayer()
    var playlists: [Playlist] = []
    var topic: String?
    var topicId: String?
    var currentIndex: Int = 0 // Currently always 0, but could be useful later
    
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
    
    public func currentVideo() -> Video? {
        return currentPlaylist()?.currentVideo()
    }
    
//    public func nextVideo() -> Video? {
//        
//        if playlists.isEmpty {
//            print("Playlists is empty, replacing queue")
//            // self.isLoading = true
//            
//            Task {
//                // self.playlists = await load(topicId: topicId, numPlaylists: 2)
//                // self.isLoading = false
//            }
//        }
//        
//        else if playlists[currentIndex].onLastVideo() {
//            // Dequeue current playlist
//            dequeuePlaylists()
//            
//            // Add playlist to end of sequence
//            Task {
//                await addPlaylist(topicId: topicId)
//            }
//        }
//        
//    }
//    public func skipToPlaylist(index: Int) {
//        
//        if index > playlists.count - 1 {
//            print(SequenceError.indexOutOfRange)
//            return
//        }
//        
//        if index <= 0 {
//            return
//        }
//        
//        // Fill in the back of the queue
//        let numSkipped = index - currentIndex
//        addPlaylists(numPlaylists: numSkipped)
//        
//        // Dequeue skipped playlists
//        dequeuePlaylists(numPlaylists: index)
//    
//        // currentIndex should still be 0
//    }

    func next(swipeDirection: SwipeDirection) {
        
        if playlists.isEmpty {
            print("Playlists is empty, replacing queue")
            // self.isLoading = true
            
            Task {
                // self.playlists = await load(topicId: topicId, numPlaylists: 2)
                // self.isLoading = false
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
                // self.playlists = await load(topicId: nil, numPlaylists: 2)
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
        // player.replaceCurrentItem(with: playerItem)
    }

    func currentVideo() -> AVPlayerItem? {
        if !playlists.isEmpty {
            let video = playlists[currentIndex].currentVideo()
            if let video { return AVPlayerItem(url: URL(string: (video.getURL()))!) }
        }
        return nil
    }
    
//    func nextVideo(swipeDirection: SwipeDirection) {
//
//        // If swiped right, keep playing the current sequence
//        if swipeDirection == .right {
//            
//            // If queue is empty for whatever reason, fetch new sequence
//            if playlists.isEmpty {
//                print("Playlists is empty, replacing queue")
//                addPlaylists(topic: topic, topicId: topicId)
//
//            // If current playlist is on last video
//            } else if playlists[currentIndex].onLastVideo() {
//                
//                // Dequeue current playlist
//                dequeuePlaylists()
//                
//                // Add playlist to end of sequence
//                addPlaylists()
//            }
//        }
//        
//        // Skip current playlist
//        else if swipeDirection == .left && !playlists.isEmpty {
//                
//            // Dequeue current video
//            dequeuePlaylists()
//                
//            // Add playlist, but call with different parameters (TBD)
//            addPlaylists()
//        }
//    
//        // Make sure playlist is not empty
//        if playlists.isEmpty {
//            print("Error updating player: \(SequenceError.emptySequence.localizedDescription)")
//            return
//        }
//        
//        guard let nextVideo = playlists[currentIndex].nextVideo() else {
//            print(PlaylistError.noNextVideo.localizedDescription)
//            return
//        }
//        
//        // Update next playerItem
//        let playerItem = AVPlayerItem(url: URL(string: nextVideo.getURL())!)
//        player.replaceCurrentItem(with: playerItem)
//    }
//    
    func addPlaylist(topicId: String? = nil) async {
        do {
            let playlist = try await VideoService.fetchPlaylist(topicId: topicId)
            self.playlists.append(playlist)
        } catch {
            print("Failed to add playlist: \(error)")
        }
    }
//    
//    func addPlaylists(topic: String? = nil, topicId: String? = nil, numPlaylists: Int = 1) {
//        let query: PlaylistQuery = PlaylistQuery(topic: topic,
//                                                 topicId: topicId,
//                                                 numPlaylists: numPlaylists)
//        self.fetchSuccessful = false
//        self.isLoading = true
//
//        VideoService.fetchSequence(query: query) { sequence in
//            self.playlists += sequence.playlists
//            print("Sequence loaded with \(sequence.playlists.count) playlists.")
//            self.topic = sequence.topic
//            self.fetchSuccessful = true
//            self.player.replaceCurrentItem(with: self.currentVideo())
//            self.isLoading = false
//            
//        } failure: { error in
//            print("Couldn't fetch sequence from specified topic: \(error)")
//        }
//
//    }

    private func dequeuePlaylists(numPlaylists: Int = 1) {
        print("Dequeuing \(numPlaylists) playlists...")
        
        if numPlaylists > playlists.count {
            print("Error: \(PlaylistError.emptyPlaylist.localizedDescription)")
            return
        }
        
        playlists.removeFirst(numPlaylists)
    }

}
