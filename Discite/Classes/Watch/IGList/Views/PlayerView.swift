//
//  PlayerView.swift
//  Discite
//
//  Created by Jessie Li on 3/7/24.
//

import AVFoundation
import UIKit

class PlayerView: UIView {

    // Override the property to make AVPlayerLayer the view's backing layer
    override static var layerClass: AnyClass {
        AVPlayerLayer.self
    }
    
    var player: AVPlayer? {
        get { playerLayer.player }
        set { playerLayer.player = newValue }
    }
    
    var playerLayer: AVPlayerLayer {
        layer as? AVPlayerLayer ?? AVPlayerLayer()
    }
    
    var playerItem: AVPlayerItem? {
        didSet {
            // Configure player item here if needed
            player?.replaceCurrentItem(with: self.playerItem)
        }
    }
    
    var video: Video?
    
    private lazy var overlayViewController: PlayerOverlayViewController = {
        let overlayController = PlayerOverlayViewController()
        let view = overlayController.view
        view?.contentMode = .scaleAspectFill
        view?.clipsToBounds = true
        view?.isHidden = true
        view?.layer.borderColor = UIColor.systemPink.cgColor
        return overlayController
    }()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        return gesture
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Add controls and overlay
        addGestureRecognizer(tapGesture)
        addSubview(overlayViewController.view)
        
        // Configure playerLayer
        setupVideoPlayer()
        
        // Add observer to listen for end of player so we can loop it
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerItemDidReachEnd(notification:)),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem)
    }
    
    func setupVideoPlayer() {
        self.player = AVPlayer.init(playerItem: self.playerItem)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        player?.volume = 3
        player?.actionAtItemEnd = .none
        
        self.backgroundColor = .clear
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.playerItemDidReachEnd(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem)
        
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem: AVPlayerItem = notification.object as? AVPlayerItem {
            print("Got notification to rewind")
            
            //        playerItem.seek(to: CMTime.zero) { success in
            //            print("\tRewind player: \(success)")
            //        }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bounds = bounds
        overlayViewController.view.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3) {
            self.overlayViewController.view.isHidden.toggle()
        }
    }
    
    public func hideOverlay() {
        overlayViewController.view.isHidden = true
    }
    
    public func configureOverlay() {
        overlayViewController.player = player
        overlayViewController.video = video
    }
    
    deinit {
        player = nil
        NotificationCenter.default.removeObserver(self)
    }
}
