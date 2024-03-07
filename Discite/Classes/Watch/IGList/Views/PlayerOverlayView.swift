//
//  PlayerOverlayView.swift
//  Discite
//
//  Created by Jessie Li on 3/7/24.
//

import Foundation
import UIKit
import AVKit

class PlayerOverlayView: UIView {
    var player: AVPlayer? {
        didSet {
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }

    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [metadataStackView, controlsStackView])
        stackView.axis = .horizontal
        stackView.spacing = 32
        stackView.alignment = .bottom
        stackView.tintColor = .white
        return stackView
    }()
    
    private lazy var controlsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [likeButton, dislikeButton, bookmarkButton, shareButton, detailsButton])
        stackView.axis = .vertical
        stackView.spacing = 24
        return stackView
    }()
    
    private lazy var playbackStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [skipBackwardButton, playPauseButton, skipForwardButton])
        stackView.axis = .horizontal
        stackView.spacing = 40
        return stackView
    }()
    
    private lazy var metadataStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var playPauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        button.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        button.tintColor = UIColor.white
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private lazy var skipForwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "forward.fill"), for: .normal)
        button.addTarget(self, action: #selector(skipForwardButtonTapped), for: .touchUpInside)
        button.tintColor = UIColor.white
        return button
    }()
    
    private lazy var skipBackwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "backward.fill"), for: .normal)
        button.addTarget(self, action: #selector(skipBackwardButtonTapped), for: .touchUpInside)
        button.tintColor = UIColor.white
        return button
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        button.tintColor = UIColor.white
        return button
    }()

    private lazy var dislikeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "hand.thumbsdown"), for: .normal)
        button.addTarget(self, action: #selector(dislikeButtonTapped), for: .touchUpInside)
        button.tintColor = UIColor.white
        return button
    }()

    private lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        button.tintColor = UIColor.white
        return button
    }()

    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "paperplane"), for: .normal)
        button.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        button.tintColor = UIColor.white
        return button
    }()

    private lazy var detailsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.addTarget(self, action: #selector(detailsButtonTapped), for: .touchUpInside)
        button.tintColor = UIColor.white
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2
        return label
   }()
   
   private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description of the playlist goes here. Adding words to ensure that text wraps when the description is long, and is limited to two lines."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.numberOfLines = 2
        return label
   }()
    
    @objc private func likeButtonTapped() {
        // Handle thumbs up action
    }

    @objc private func dislikeButtonTapped() {
        // Handle thumbs down action
    }

    @objc private func bookmarkButtonTapped() {
        // Handle bookmark action
    }

    @objc private func shareButtonTapped() {
        // Handle share action
    }

    @objc private func detailsButtonTapped() {
        // Handle details action
    }
    
    @objc private func playPauseButtonTapped() {
        guard let player = player else {
            print("player is nil")
            return
        }
        
        if player.rate == 0 {
            print("Playing...")
            player.play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            
        } else {
            print("Pausing...")
            player.pause()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }

    @objc private func skipForwardButtonTapped() {
        // Implement skip forward logic here
        // Adjust the time by 10 seconds (or your desired duration)
    }

    @objc private func skipBackwardButtonTapped() {
        // Implement skip backward logic here
        // Adjust the time by -10 seconds (or your desired duration)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        // addSubview(controlsStackView)
        addSubview(playbackStackView)
        // addSubview(metadataStackView)
        addSubview(bottomStackView)
        setupConstraints()
    }

    private func setupConstraints() {
        // controlsStackView.translatesAutoresizingMaskIntoConstraints = false
        playbackStackView.translatesAutoresizingMaskIntoConstraints = false
        // metadataStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
//            controlsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
//            controlsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -48),
             playbackStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
             playbackStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            bottomStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            bottomStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            bottomStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -48)
//            metadataStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
//            metadataStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -48),
//            metadataStackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -54)
        ])
    }
}
