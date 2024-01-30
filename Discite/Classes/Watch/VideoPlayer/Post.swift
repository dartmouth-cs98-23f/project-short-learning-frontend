//
//  Post.swift
//  Discite
//
//  Created by Jessie Li on 1/23/24.
//

import SwiftUI
import AVKit
import Combine

struct Post: View {
    @ObservedObject var playlist: Playlist
    @State var scrollPosition: Int?

    var player: AVPlayer
    
    var body: some View {
        
        if playlist.isLoading {
            ProgressView("Loading playlist...")
                .containerRelativeFrame([.horizontal, .vertical])
            
        } else {
            ZStack(alignment: .top) {
                
                // Background
                ZStack {
                    Rectangle()
                        .fill(.black)
                        .containerRelativeFrame([.horizontal, .vertical])
                    
                    Text("Post: \(playlist.id)")
                        .foregroundColor(.white)
                }
                
                // Horizontal carousel
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        ForEach(0..<playlist.videos.count, id: \.self) { index in
                            VideoView(player: player)
                                .id(index)
                                .onAppear {
                                    initialPlay()
                                }
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.paging)

                .scrollPosition(id: $scrollPosition)
                .ignoresSafeArea()
                .onAppear {
                   player.play()
               }
                .onChange(of: scrollPosition) { _, new in
                    // Update current index
                    _ = playlist.setCurrentIndex(index: new ?? 0)
                    
                    // Update player
                    updatePlayer()
                    if self.player.rate == 0 && self.player.error == nil {
                        player.play()
                    }
            
                }
                
                // Navigation
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
        }
    }
    
    // When Watch first launches, manually play first video
    func initialPlay() {
        guard
            scrollPosition == nil,
            let video = playlist.currentVideo(),
            player.currentItem == nil else { return }

        let playerItem = video.getPlayerItem()
        player.replaceCurrentItem(with: playerItem)
    }
    
    func updatePlayer() {
        guard let currentVideo = playlist.currentVideo() else {
            return
        }

        player.replaceCurrentItem(with: nil)
        let playerItem = currentVideo.getPlayerItem()
        player.replaceCurrentItem(with: playerItem)
    }
   
    func dotNavigation(position: Int, length: Int) -> some View {
        HStack(spacing: 10) {
            ForEach(0..<playlist.videos.count, id: \.self) { index in
                if playlist.currentIndex == index {
                    Circle()
                        .fill(Color.primaryPurpleLightest.opacity(1))
                        .frame(width: 12, height: 12)
                } else {
                    Circle()
                        .fill(Color.primaryPurpleLight.opacity(0.5))
                        .frame(width: 8, height: 8)
                }
            }
        }
    }
    
    // Horizontal scroll section for video thumbnails
    func imageCarousel(videos: [Video]) -> some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(videos) { _ in
                    VideoView(player: player)
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
