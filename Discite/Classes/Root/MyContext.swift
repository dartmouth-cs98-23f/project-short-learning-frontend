//
//  MyContext.swift
//  Discite
//
//  Created by Jessie Li on 12/15/23.
//

import Foundation
import AVFoundation

class MyContext: ObservableObject {
    
    @Published var player: AVPlayer = AVPlayer()
    var playlists: [Playlist] = []
    var currentIndex = 0
    
    var topics: [Topic] = []
    
    func loadContext() async {
        do {
            async let playlists = VideoService.loadPlaylists()
            async let topics = ExploreService.loadTopics()
            
            self.playlists = try await playlists
            self.topics = await topics
            
            print("Sequence loaded.")
            
            if !self.playlists.isEmpty {
                let playerItem = self.playlists[0].nextPlayerItem()
                player.replaceCurrentItem(with: playerItem)
                objectWillChange.send()
            }
            
        } catch {
            print("Failed to load content.")
        }
    }
    
    func reloadPlaylists() async {
        do {
            playlists = try await VideoService.loadPlaylists()
           
            if !self.playlists.isEmpty {
                let playerItem = self.playlists[0].nextPlayerItem()
                player.replaceCurrentItem(with: playerItem)
                objectWillChange.send()
                print("Reloaded.")
            }
        } catch {
            print("Failed to reload context sequence.")
        }
    }
}
