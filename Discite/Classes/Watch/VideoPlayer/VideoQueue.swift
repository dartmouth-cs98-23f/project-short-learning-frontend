//
//  TestVideoQueue.swift
//  Discite
//
//  Created by Jessie Li on 10/27/23.
//

import AVKit

struct Video {
    var index: Int
    var data: VideoData?
    var playerItem: AVPlayerItem
}

class VideoQueue: ObservableObject {
    
    @Published var player: AVPlayer = AVPlayer()
    @Published var fetchSuccessful: Bool = false
    @Published var fetchError: APIError?
    
    private(set) var title: String?
    private(set) var description: String?
    private(set) var creator: User?
    
    private(set) var videoQueue: [Video] = []
    var currentIndex: Int = 0
    
    private var videoService: TestVideoService = TestVideoService.shared

    init() {
        let playerItem1 = AVPlayerItem(url: Bundle.main.url(forResource: "video1", withExtension: "mp4")!)
        let playerItem2 = AVPlayerItem(url: Bundle.main.url(forResource: "video2", withExtension: "mp4")!)
        
        var index = 0
        for playerItem in [playerItem1, playerItem2] {
            let video = Video(index: index, data: nil, playerItem: playerItem)
            videoQueue.append(video)
            
            index += 1
        }
        
        nextVideo()
    }
    
    // MARK: Public Getters
    
    func getQueueTitle() -> String {
        return title ?? "Untitled Playlist"
    }
    
    func getQueueDescription() -> String {
        return description ?? "No description available for this playlist."
    }
    
    func getQueueCreator() -> User {
        return creator ?? User.anonymousUser
    }
    
    func queueLength() -> Int {
        return videoQueue.count
    }
    
    func queueIsEmpty() -> Bool {
        return videoQueue.isEmpty
    }
    
    func getCurrentIndex() -> Int {
        return currentIndex
    }
    
    func getVideo(index: Int) -> Video? {
        if index > videoQueue.count {
            return nil
        }
        
        return videoQueue[index]
    }
    
    func getAllVideos() -> [Video] {
        return videoQueue
    }
    
    // MARK: Public Setters
    
    func setCurrentIndex(currentIndex: Int) {
        self.currentIndex = currentIndex
    }
    
    // MARK: Queue Management
    
    // Advance to the next video in the queue, if none left, fetch the next playlist
    func nextVideo() {

        if self.currentIndex < self.videoQueue.count {
            let nextVideo: Video = self.videoQueue[self.currentIndex]
            player.replaceCurrentItem(with: nextVideo.playerItem)
            self.currentIndex += 1
            
        } else {
            // Retrieve the next playlist
            fetchNextPlaylist()
            
            if !self.videoQueue.isEmpty {
                self.currentIndex = 0
                let nextVideo: Video = self.videoQueue[0]
                player.replaceCurrentItem(with: nextVideo.playerItem)
            }
        }
    }
    
    // Fetch videos from an API and add them to the queue
    func fetchNextPlaylist() {
        
        var nextVideoQueue: [Video] = []
        var index = 0
        
        for id in ["6748095", "6747803", "6747794"] {
            videoService.fetchVideo(videoId: id) { videoData in
                self.fetchError = nil
                self.fetchSuccessful = true
                
                // Choose the HLS video file
                let videoFile = videoData.videoFiles[5]
                let playerItem = AVPlayerItem(url: URL(string: videoFile.link)!)
                
                // Add this video to the queue
                let video: Video = Video(index: index, data: videoData, playerItem: playerItem)
                nextVideoQueue.append(video)
                index += 1

            } failure: { error in
                self.fetchError = error
                self.fetchSuccessful = false
                return
            }
        }
        
        // Replace videos from an API and add them to the queue
        self.videoQueue = nextVideoQueue
        self.currentIndex = 0
        
        // Update title, description, and creator of playlist
        
        // Start playing this queue
        self.nextVideo()

    }
}
