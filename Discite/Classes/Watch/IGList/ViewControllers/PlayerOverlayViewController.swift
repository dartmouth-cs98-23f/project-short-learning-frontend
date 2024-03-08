//
//  PlayerOverlayViewController.swift
//  Discite
//
//  Created by Jessie Li on 3/7/24.
//

import Foundation
import UIKit
import AVKit
import SwiftUI

class PlayerOverlayViewController: UIViewController, PlayerOverlayDelegate {

    var player: AVPlayer? {
        didSet {
            playerControlsView.player = player
        }
    }
    
    var video: Video? {
        didSet {
            playerControlsView.video = video
        }
    }
    
    private let playerControlsView = PlayerOverlayView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerControlsView.player = player
        playerControlsView.delegate = self
        
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
    
    // MARK: PlayerOverlayDelegate
    func presentShareController() {
        #if DEBUG
        print("\tIn presentDetailsView.")
        #endif
        
        guard let playlist = video?.playlist else { return }
        
        let shareView = SharePage(playlist: playlist)
        let shareController = UIHostingController(rootView: shareView)
        self.present(shareController, animated: true, completion: nil)
    }
    
    func presentDetailsView() {
        #if DEBUG
        print("\tIn presentDetailsView.")
        #endif
        
        guard let playlist = video?.playlist else { return }
        
        let detailsView = PlaylistSummaryView(playlist: playlist)
        let detailsController = UIHostingController(rootView: detailsView)
        self.present(detailsController, animated: true, completion: nil)
    }
}

protocol PlayerOverlayDelegate: AnyObject {
    func presentShareController()
    func presentDetailsView()
}
