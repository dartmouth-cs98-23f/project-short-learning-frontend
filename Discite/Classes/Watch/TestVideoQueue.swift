//
//  TestVideoQueue.swift
//  Discite
//
//  Created by Jessie Li on 10/27/23.
//

import AVKit

class TestVideoQueue {
    
    @Published var player: AVPlayer = AVPlayer()
    
    private var playerQueue: [AVPlayerItem] = []
    
    init() {
        let playerItem1 = AVPlayerItem(url: Bundle.main.url(forResource: "video1", withExtension: "mp4")!)
        let playerItem2 = AVPlayerItem(url: Bundle.main.url(forResource: "video2", withExtension: "mp4")!)
        let playerItem3 = AVPlayerItem(url: Bundle.main.url(forResource: "video3", withExtension: "mp4")!)
        
        for playerItem in [playerItem1, playerItem2, playerItem3] {
            playerQueue.append(playerItem)
        }
        
        nextVideo()
    }
    
    func nextVideo() {
        if !self.playerQueue.isEmpty {
            let nextPlayerItem = self.playerQueue.removeFirst()
            player.replaceCurrentItem(with: nextPlayerItem)
        }
    }
}
