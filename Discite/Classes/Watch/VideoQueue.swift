//
//  TestVideoQueue.swift
//  Discite
//
//  Created by Jessie Li on 10/27/23.
//

import AVKit

class VideoQueue: ObservableObject {
    
    @Published var player: AVPlayer = AVPlayer()
    @Published var fetchSuccessful: Bool = false
    @Published var fetchError: APIError?
    
    private var playerQueue: [AVPlayerItem] = []
    private var videoService: TestVideoService = TestVideoService()

    init() {
        let playerItem1 = AVPlayerItem(url: Bundle.main.url(forResource: "video1", withExtension: "mp4")!)
        let playerItem2 = AVPlayerItem(url: Bundle.main.url(forResource: "video2", withExtension: "mp4")!)
        let playerItem3 = AVPlayerItem(url: Bundle.main.url(forResource: "video3", withExtension: "mp4")!)
        
        for playerItem in [playerItem1, playerItem2, playerItem3] {
            playerQueue.append(playerItem)
        }
        
        nextVideo()
    }
    
    // Advance to the next video in the queue, if there is one
    func nextVideo() {
        if !self.playerQueue.isEmpty {
            let nextPlayerItem = self.playerQueue.removeFirst()
            player.replaceCurrentItem(with: nextPlayerItem)
        }
    }
    
    // Fetch videos from an API and add them to the queue
    func fetchVideos() {
        videoService.fetchVideos(videoId: "2499611") { (_) in
            self.fetchError = nil
            self.fetchSuccessful = true
            
            // Add the video to the queue
            
        } failure: { error in
            self.fetchError = error
            self.fetchSuccessful = false
        }

    }
}
