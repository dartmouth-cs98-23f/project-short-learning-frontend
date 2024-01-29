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
    @State private var scrollPosition: Int?
    
    var player: AVPlayer
    
    var body: some View {
        
        if playlist.isLoading {
            ProgressView("Loading playlist...")
                .containerRelativeFrame([.horizontal, .vertical])
            
        } else {
            ZStack(alignment: .top) {
                ZStack {
                    Rectangle()
                        .fill(.pink)
                        .containerRelativeFrame([.horizontal, .vertical])
                    
                    Text("Post: \(playlist.id)")
                        .foregroundColor(.white)
                }
                
                imageCarousel(videos: playlist.videos)
                    .scrollTargetBehavior(.paging)
                    .scrollPosition(id: $scrollPosition)
                    .ignoresSafeArea()
                    .onChange(of: scrollPosition) {
                        
                        // Update current index
                        let newIndex = (scrollPosition ?? 1) - 1
                        _ = playlist.setCurrentIndex(index: newIndex)
                        
                        // Update player
                        updatePlayer(video: playlist.currentVideo())
                        if self.player.rate == 0 && self.player.error == nil {
                            player.play()
                        }
                    }
                
//                CustomVideoPlayer(player: player)
//                    .containerRelativeFrame([.horizontal, .vertical])
                
                VStack {
                    dotNavigation(position: playlist.currentIndex, length: playlist.videos.count)
                        .padding(.top, 24)
                    
                    Spacer()
                    
                    HStack(alignment: .bottom) {
                        Spacer()
                        actionButtons()
                    }
                }
                .padding([.top, .bottom], 36)
                .padding([.leading, .trailing], 24)

            }
            .onAppear {
                // Should we move the player play here?
                initialPlay() 
                addObserver()
                // initialPlay()
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
    
    // When Watch first launches, manually play first video
    func initialPlay() {
        guard
            scrollPosition == nil,
            player.currentItem == nil,
            let video = playlist.currentVideo()
        else { return }
        
        let playerItem = video.getPlayerItem()
        player.replaceCurrentItem(with: playerItem)
    }
    
    // Update player on horizontal scroll
    func updatePlayer(video: Video?) {
        print("POST: update player")
        guard let video else { return }
        player.replaceCurrentItem(with: nil)
        let playerItem = video.getPlayerItem()
        player.replaceCurrentItem(with: playerItem)
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
    
    // Horizontal scroll section for video thumbnails
    func imageCarousel(videos: [Video]) -> some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(Array(videos.enumerated()), id: \.element.id) { index, video in
                    AsyncImage(url: URL(string: video.image)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .containerRelativeFrame([.horizontal, .vertical])
                        
                    } placeholder: {
                        ProgressView()
                    }
                    .id(index)
                }
            }
            .scrollTargetLayout()
        }
    }
    
    func actionButtons() -> some View {
        VStack(spacing: 24) {
            Button {
                
            } label: {
                Image(systemName: "bookmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .foregroundColor(.white)
            }
            
            Button {
                
            } label: {
                Image(systemName: "paperplane")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .foregroundColor(.white)
            }
            
            Button {
                
            } label: {
                Image(systemName: "hand.thumbsup")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .foregroundColor(.white)
            }
            
            Button {
                
            } label: {
                Image(systemName: "hand.thumbsdown")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .foregroundColor(.white)
            }
            
        }
    }
}
