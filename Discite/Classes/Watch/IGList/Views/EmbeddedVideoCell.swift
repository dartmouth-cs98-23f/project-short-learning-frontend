//
//  EmbeddedVideoCell.swift
//  Discite
//
//  Created by Jessie Li on 3/7/24.
//
//  Based on: IGListKit iOS Examples, ImageCell.swift
//      https://github.com/Instagram/IGListKit/blob/main/Examples/Examples-iOS/IGListKitExamples/Views/ImageCell.swift

import AVKit

class EmbeddedVideoCell: UICollectionViewCell {
    
    var video: Video?
    
    var task: Task<Void, Error>? {
        willSet {
            if let currentTask = task {
                if currentTask.isCancelled { return }
                currentTask.cancel()
                // Setting a new task cancelling the current task
            }
        }
    }
    
    fileprivate let playerView: PlayerView = {
        let view = PlayerView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = UIColor.black
        return view
    }()

    fileprivate let activityView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = UIActivityIndicatorView.Style.medium
        view.startAnimating()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(playerView)
        contentView.addSubview(activityView)
        
    }
    
    public func configureWithVideo(video: Video?) {
        playerView.video = video
        
        if let url = video?.videoLink {
            let playerItem = AVPlayerItem(url: url)
            configureWithPlayerItem(playerItem: playerItem)
        }
    }
    
    public func configureWithPlayerItem(playerItem: AVPlayerItem?) {
        playerView.playerItem = playerItem
        
        if playerView.playerItem != nil && playerView.player != nil {
            playerView.configureOverlay()
            activityView.stopAnimating()
            
        } else {
            print("Tried to configure, but player was nil.")
            activityView.startAnimating()
        }
    }
    
    public func hideOverlay() {
        self.playerView.hideOverlay()
    }
    
    public func stopPlaybackInPlayerView() {
        self.playerView.player?.pause()
        
        #if DEBUG
        print("\t\tStopped playback, posting watch history for \(playerView.video?.videoId ?? "None")")
        #endif
        
        // Post timestamp
        if let player = playerView.player, let currentPlayerItem = player.currentItem {
            let totalDuration = CMTimeGetSeconds(currentPlayerItem.duration)
            let currentTime =  CMTimeGetSeconds(player.currentTime())
            
            let totalTime = Double(playerView.loops) * totalDuration + currentTime
            task = Task { await playerView.video?.postWatchHistory(timestamp: totalTime) }
        }
    }
    
    public func startPlaybackInPlayerView() {
        if self.playerView.player?.rate == 0 {
            // self.playerView.player?.seek(to: CMTime.zero)
            self.playerView.player?.play()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bounds = contentView.bounds
        activityView.center = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
        playerView.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(with player: AVPlayer?) {
        playerView.player = player
        playerView.configureOverlay()
        
        if playerView.player != nil {
            print("Configured player view with valid player.")
            activityView.stopAnimating()
        } else {
            print("Tried to configure, but player was nil.")
            activityView.startAnimating()
        }
    }
    
    deinit {
        task?.cancel()
    }
    
}
