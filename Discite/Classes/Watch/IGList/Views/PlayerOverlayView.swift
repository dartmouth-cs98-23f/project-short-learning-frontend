//
//  PlayerOverlayView.swift
//  Discite
//
//  Created by Jessie Li on 3/7/24.
//

import Foundation
import UIKit
import AVKit
import SwiftUI

class PlayerOverlayView: UIView {
    var player: AVPlayer? {
        didSet {
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }

    var video: Video? {
        didSet {
            titleLabel.text = video?.playlist?.title ?? "Untitled"
            descriptionLabel.text = video?.playlist?.description ?? "No description available."
            videoWrapper.video = video
            bookmarkButton.setImage(video?.playlist?.isSaved ?? false
                ? UIImage(systemName: "bookmark.fill")
                : UIImage(systemName: "bookmark"), for: .normal)
        }
    }

    var task: Task<Void, Error>? {
        willSet {
            if let currentTask = task {
                if currentTask.isCancelled { return }
                currentTask.cancel()
                // Setting a new task cancelling the current task
            }
        }
    }

    weak var delegate: PlayerOverlayDelegate?
    private var videoWrapper = VideoWrapper()

    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [metadataStackView, controlsStackView])
        stackView.axis = .horizontal
        stackView.spacing = 32
        stackView.alignment = .bottom
        stackView.tintColor = .white

        let stackViewWithNavigation = UIStackView(arrangedSubviews: [stackView, navigationBar])
        stackViewWithNavigation.axis = .vertical
        stackViewWithNavigation.spacing = 12
        return stackViewWithNavigation
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
        let stackView = UIStackView(arrangedSubviews: [youtubeButton, titleLabel, descriptionLabel])
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
        label.text = "Untitled"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "No description available."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()

    private lazy var progressDots: UIView = {
        let controller = UIHostingController(rootView: NavigationDotsView(videoWrapper: videoWrapper))
        controller.view.backgroundColor = .clear
        return controller.view
    }()

    private lazy var youtubeButton: UIView = {
        let controller = UIHostingController(rootView: YouTubeButton(video: video))
        controller.view.backgroundColor = .clear
        return controller.view
    }()

    private lazy var navigationBar: UIView = {
        let controller = UIHostingController(rootView: NavigationBar(
            foregroundColor: .secondaryPeachLight,
            backgroundColor: .clear)
        )

        controller.view.backgroundColor = .clear
        return controller.view
    }()

    @objc private func likeButtonTapped() {
        #if DEBUG
        print("\tLike button tapped.")
        #endif

        guard
            let video = video,
            let playlist = video.playlist
        else { return }

        playlist.isLiked.toggle()

        if playlist.isLiked && playlist.isDisliked {
            playlist.isDisliked = false
        }

        task = Task {
            playlist.isLiked
            ? await playlist.postLike()
            : await playlist.deleteLike()
        }

        if playlist.isLiked {
            likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
            likeButton.tintColor = .systemIndigo
            dislikeButton.setImage(UIImage(systemName: "hand.thumbsdown"), for: .normal)
            dislikeButton.tintColor = .white
        } else {
            likeButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
            likeButton.tintColor = .white
        }
    }

    @objc private func dislikeButtonTapped() {
        #if DEBUG
        print("\tDislike button tapped.")
        #endif

        guard
            let video = video,
            let playlist = video.playlist
        else { return }

        playlist.isDisliked.toggle()

        if playlist.isLiked && playlist.isDisliked {
            playlist.isLiked = false
        }

        task = Task {
            playlist.isDisliked
            ? await playlist.postDislike()
            : await playlist.deleteDislike()
        }

        if playlist.isDisliked {
            dislikeButton.setImage(UIImage(systemName: "hand.thumbsdown.fill"), for: .normal)
            dislikeButton.tintColor = .systemPink
            likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
            likeButton.tintColor = .white
            delegate?.dislikeButtonTapped(disliked: true)

        } else {
            dislikeButton.setImage(UIImage(systemName: "hand.thumbsdown"), for: .normal)
            dislikeButton.tintColor = .white
        }
    }

    @objc private func bookmarkButtonTapped() {
        #if DEBUG
        print("\tSave button tapped.")
        #endif

        guard
            let video = video,
            let playlist = video.playlist
        else { return }

        task = Task {
            playlist.isSaved
            ? await playlist.deleteSave()
            : await playlist.putSave()

            bookmarkButton.setImage(
                playlist.isSaved
                ? UIImage(systemName: "bookmark.fill")
                : UIImage(systemName: "bookmark"), for: .normal)
        }
    }

    @objc private func shareButtonTapped() {
        #if DEBUG
        print("\tShare button tapped.")
        #endif

        delegate?.presentShareController()
    }

    @objc private func detailsButtonTapped() {
        #if DEBUG
        print("\tDetails button tapped.")
        #endif

        delegate?.presentDetailsView()
    }

    @objc private func playPauseButtonTapped() {
        guard let player = player else {
            return
        }

        if player.rate == 0 {
            #if DEBUG
            print("Playing...")
            #endif

            player.play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)

        } else {
            #if DEBUG
            print("Pausing...")
            #endif

            player.pause()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }

    @objc private func skipForwardButtonTapped() {
        guard let player = player else { return }

        // Calculate the new time
        let currentTime = player.currentTime()
        let newTime = CMTime(seconds: currentTime.seconds + 10, preferredTimescale: currentTime.timescale)

        // Seek to the new time
        player.seek(to: newTime)
    }

    @objc private func skipBackwardButtonTapped() {
        guard let player = player else { return }

        // Calculate the new time
        let currentTime = player.currentTime()
        let newTime = CMTime(seconds: currentTime.seconds - 10, preferredTimescale: currentTime.timescale)

        // Seek to the new time
        player.seek(to: newTime)
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
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        addSubview(progressDots)
        addSubview(playbackStackView)
        addSubview(bottomStackView)

        setupConstraints()
    }

    private func setupConstraints() {
        progressDots.translatesAutoresizingMaskIntoConstraints = false
        playbackStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            progressDots.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressDots.topAnchor.constraint(equalTo: topAnchor, constant: 18),

            playbackStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            playbackStackView.centerXAnchor.constraint(equalTo: centerXAnchor),

            bottomStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            bottomStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            bottomStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)
        ])
    }

    deinit {
        task?.cancel()
    }
}

protocol PlaylistDetailsDelegate: AnyObject {
    func playPauseButtonTapped()
    func skipForwardButtonTapped()
    func skipBackwardButtonTapped()
}
