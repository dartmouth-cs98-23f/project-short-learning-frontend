//
//  SinglePlaylistWatchRepresentable.swift
//  Discite
//
//  Created by Jessie Li on 3/9/24.
//

import Foundation
import SwiftUI

struct SinglePlaylistWatchRepresentable: UIViewControllerRepresentable {
    let playlist: Playlist
    
    func makeUIViewController(context: Context) -> WorkingRangeViewController {
        let controller = WorkingRangeViewController(data: playlist.videos)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: WorkingRangeViewController, context: Context) {
        
    }
}
