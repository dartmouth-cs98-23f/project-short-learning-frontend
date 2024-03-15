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

    // How many times this player looped
    private(set) var loops: Int = 0

    private lazy var overlayViewController: PlayerOverlayViewController = {
        let overlayController = PlayerOverlayViewController()
        let view = overlayController.view
        view?.contentMode = .scaleAspectFill
        view?.clipsToBounds = true
        view?.isHidden = true
        view?.layer.borderColor = UIColor.systemPink.cgColor
        return overlayController
    }()

    private let heartImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "hand.thumbsup.fill"))
        imageView.tintColor = UIColor.red
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()

    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        return gesture
    }()

    private lazy var doubleTapGesture: UITapGestureRecognizer = {
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        return doubleTapGesture
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        // Add controls and overlay
        addGestureRecognizer(tapGesture)
        // addGestureRecognizer(doubleTapGesture)
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

    private func setupHeartImageView() {
        addSubview(heartImageView)
        heartImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heartImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            heartImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            heartImageView.widthAnchor.constraint(equalToConstant: 50),
            heartImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
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

    // A notification is fired and seeker is sent to the beginning to loop the video again
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem: AVPlayerItem = notification.object as? AVPlayerItem {
            loops += 1
            playerItem.seek(to: CMTime.zero) { success in
                print("\tRewind player: \(success)")
            }
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

    @objc private func handleDoubleTap() {
        // Show like
        heartImageView.isHidden = false

        // Animate the heart image
        UIView.animate(withDuration: 1.0, animations: {
            self.heartImageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }, completion: { _ in
            // Hide the heart image after the animation completes
            self.heartImageView.isHidden = true
            self.heartImageView.transform = .identity
        })
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
