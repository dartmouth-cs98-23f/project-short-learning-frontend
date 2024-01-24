//
//  Post.swift
//  Discite
//
//  Created by Jessie Li on 1/23/24.
//

import SwiftUI
import AVKit

struct Post: View {
    @ObservedObject var playlist: Playlist
    var player: AVPlayer
    var body: some View {
        
        if playlist.isLoading {
            ProgressView("Loading playlist...")
                .containerRelativeFrame([.horizontal, .vertical])
                .border(.pink)
            
        } else {
            ZStack(alignment: .top) {
                
                ZStack {
                    Rectangle()
                        .fill(.pink)
                        .containerRelativeFrame([.horizontal, .vertical])
                    
                    Text("Post: \(playlist.id)")
                        .foregroundColor(.white)
                }
                
                CustomVideoPlayer(player: player)
                    .containerRelativeFrame([.horizontal, .vertical])

            }
            .onAppear {
                print("DEBUG: Post appeared: \(playlist.id)")
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
   
    func dotNavigation(position: Int, length: Int) -> some View {
        HStack(spacing: 8) {
            ForEach(0..<playlist.videos.count, id: \.self) { index in
                Circle()
                    .fill(Color.primaryPurple.opacity(playlist.currentIndex == index ? 1 : 0.33))
                    .frame(width: 8, height: 8)
            }
        }
    }
}
