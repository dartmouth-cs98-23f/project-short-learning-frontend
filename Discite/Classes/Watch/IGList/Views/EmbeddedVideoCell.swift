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
    
    // OPTION 1: PLAYER
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    var paused: Bool = false
    
    var playerItem: AVPlayerItem? {
        didSet {
            // Configure here if needed
            player?.replaceCurrentItem(with: self.playerItem)
        }
    }
    
    // OPTION 2
    fileprivate let playerView: PlayerView = {
        let view = PlayerView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = UIColor.secondarySystemBackground
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
    }
    
    public func startPlaybackInPlayerView() {
        if self.playerView.player?.rate == 0 {
            // self.playerView.player?.seek(to: CMTime.zero)
            self.playerView.player?.play()
        }
    }
    
    // A notification is fired and seeker is sent to the beginning to loop the video again
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem: AVPlayerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero) { success in
                print("\tRewind player: \(success)")
            }
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
        player = nil
        NotificationCenter.default.removeObserver(self)
    }
    
}
