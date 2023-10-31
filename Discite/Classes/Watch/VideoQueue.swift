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
    
    private(set) var playerQueue: [AVPlayerItem] = []
    var currentIndex: Int = 0
    
    private var videoService: TestVideoService = TestVideoService()

    init() {
        let playerItem1 = AVPlayerItem(url: Bundle.main.url(forResource: "video1", withExtension: "mp4")!)
        // let playerItem2 = AVPlayerItem(url: Bundle.main.url(forResource: "video2", withExtension: "mp4")!)
        // let playerItem3 = AVPlayerItem(url: Bundle.main.url(forResource: "video3", withExtension: "mp4")!)
        
        for playerItem in [playerItem1] {
           playerQueue.append(playerItem)
        }
        
        nextVideo()
    }
    
    func queueLength() -> Int {
        return playerQueue.count
    }
    
    func queueIsEmpty() -> Bool {
        return playerQueue.isEmpty
    }
    
    // Advance to the next video in the queue, if there is one
    func nextVideo() {
        if self.currentIndex < self.playerQueue.count {
            self.currentIndex += 1
            player.replaceCurrentItem(with: self.playerQueue[currentIndex])
        } else {
            // Retrieve the next playlist
            // fetchNextPlaylist()
            self.currentIndex = 0
        }
    }
    
    // Fetch videos from an API and add them to the queue
    func fetchNextPlaylist() {
        
        var nextPlaylist: [AVPlayerItem] = []
        
        for id in ["6748095", "6747803", "6747794"] {
            videoService.fetchVideos(videoId: id) { videoData in
                self.fetchError = nil
                self.fetchSuccessful = true
                
                // Choose the HLS video file
                let videoFile = videoData.videoFiles[5]
                let playerItem = AVPlayerItem(url: URL(string: videoFile.link)!)
                nextPlaylist.append(playerItem)

            } failure: { error in
                self.fetchError = error
                self.fetchSuccessful = false
            }
        }
        
        // Replace videos from an API and add them to the queue
        self.playerQueue = nextPlaylist
        self.currentIndex = 0
        
        // Start playing this queue
        nextVideo()
    }
}
