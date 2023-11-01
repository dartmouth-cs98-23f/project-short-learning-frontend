//
//  TestVideoQueue.swift
//  Discite
//
//  Created by Jessie Li on 10/27/23.
//
//  Sources:
//      Synchronizing a group of behaviors with DispatchGroup
//      https://stackoverflow.com/questions/48667834/swift-array-not-filled-in-completion-block
//      https://developer.apple.com/documentation/dispatch/dispatchgroup

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
    
    // Instead of storing a player instance, try storing a playerLooper for the current video
    var playerLooper: AVPlayerLooper?
    var queuePlayer: AVQueuePlayer?

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
    
    func getCurrentPlayer() -> AVPlayer {
        return player
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
    
    func play() {
        self.player.play()
    }
    
    func pause() {
        self.player.pause()
    }
    
    func seek(to: CMTime) {
        self.player.seek(to: to)
    }
    
    // Advance to the next video in the queue, if none left, fetch the next playlist
    func nextVideo() {
        removeVideoEndedNotification(player: self.player)
        
        if self.currentIndex < self.videoQueue.count {
            let nextVideo: Video = self.videoQueue[self.currentIndex]
            player.replaceCurrentItem(with: nextVideo.playerItem)
            self.currentIndex += 1
            
            play()
            addVideoEndedNotification(player: self.player)
            
        } else {
            // Retrieve the next playlist
            fetchNextPlaylist()
            
            if self.fetchSuccessful && !self.videoQueue.isEmpty {
                self.currentIndex = 0
                let nextVideo: Video = self.videoQueue[0]
                player.replaceCurrentItem(with: nextVideo.playerItem)
                
                play()
                addVideoEndedNotification(player: self.player)
            }
        }
    }
    
    func removeVideoEndedNotification(player: AVPlayer) {
        NotificationCenter
            .default
            .removeObserver(self,
                            name: .AVPlayerItemDidPlayToEndTime,
                            object: self.player.currentItem)
    }
    
    func addVideoEndedNotification(player: AVPlayer) {
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(self.videoPlayBackFinished),
                         name: .AVPlayerItemDidPlayToEndTime,
                         object: self.player.currentItem)
        
//        NotificationCenter.default.addObserver(
//            forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
//            object: self.player,
//            queue: .main) { (_) in
//
//                // Loop the video
//                self.player.seek(to: .zero)
//                self.player.play()
//        }
    }
    
    @objc func videoPlayBackFinished(_ notification: Notification) {
        self.player.seek(to: .zero)
        self.player.play()
    }
    
    // Fetch videos from an API and add them to the queue
    func fetchNextPlaylist() {
        
        self.fetchError = nil
        self.fetchSuccessful = false
        
        var nextVideoQueue: [Video] = []
        var index = 0
        
        let dispatchGroup = DispatchGroup()
        
        for id in ["3704780", "6747803", "6747794"] {
            dispatchGroup.enter()
            
            videoService.fetchVideo(videoId: id) { videoData in
                // Choose the HLS video file
                let videoFile = videoData.videoFiles[5]
                let playerItem = AVPlayerItem(url: URL(string: videoFile.link)!)
                
                // Add this video to the queue
                let video = Video(index: index, data: videoData, playerItem: playerItem)
                nextVideoQueue.append(video)
                index += 1
                
                dispatchGroup.leave()

            } failure: { error in
                self.fetchError = error
                dispatchGroup.leave()
                return
            }
        }
        
        dispatchGroup.notify(queue: .main, execute: {
            // Replace current queue with the new queue
            if !nextVideoQueue.isEmpty {
                self.videoQueue = nextVideoQueue
                self.fetchSuccessful = true
            }
            
            // Update title, description, and creator of playlist
        })
    
    }
}
