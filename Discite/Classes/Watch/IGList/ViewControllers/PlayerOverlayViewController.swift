//
//  PlayerOverlayViewController.swift
//  Discite
//
//  Created by Jessie Li on 3/7/24.
//

import Foundation
import UIKit
import AVKit

class PlayerOverlayViewController: UIViewController {

    var player: AVPlayer? {
        didSet {
            playerControlsView.player = player
        }
    }
    
    private let playerControlsView = PlayerOverlayView()

    override func viewDidLoad() {
        super.viewDidLoad()

        playerControlsView.player = player
        view.addSubview(playerControlsView)
        setupConstraints()
    }

    private func setupConstraints() {
        playerControlsView.layer.borderColor = UIColor.systemPink.cgColor
        playerControlsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            playerControlsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerControlsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerControlsView.topAnchor.constraint(equalTo: view.topAnchor),
            playerControlsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
