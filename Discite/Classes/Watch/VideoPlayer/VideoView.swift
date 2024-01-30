//
//  VideoView.swift
//  Discite
//
//  Created by Jessie Li on 1/29/24.
//

import SwiftUI
import AVKit

struct VideoView: View {
    var player: AVPlayer
    
    var body: some View {
        CustomVideoPlayer(player: player)
            .containerRelativeFrame([.horizontal, .vertical])
            .onAppear {
                addObserver()
            }
            .onDisappear {
                removeObserver()
            }
            .onTapGesture {
                switch player.timeControlStatus {
                case .paused:
                    player.play()
                case .waitingToPlayAtSpecifiedRate:
                    break
                case .playing:
                    player.pause()
                @unknown default:
                    break
                }
            }
        
    }
    
    func addObserver() {
        NotificationCenter
            .default
            .addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                         object: player.currentItem,
                         queue: .main) { (_) in
                
                player.seek(to: .zero)
                player.play()
            }
    }
    
    func removeObserver() {
        NotificationCenter
            .default
            .removeObserver(self,
                            name: .AVPlayerItemDidPlayToEndTime,
                            object: player.currentItem)
    }
}
