//
//  PostView2.swift
//  Discite
//
//  Created by Jessie Li on 2/13/24.
//

import SwiftUI

struct PostView2: View {
    @Binding var playlist: Playlist
    @Binding var likedCounter: [Like]
    
    var size: CGSize
    var safeArea: EdgeInsets
    
    @State var isPlaying = false
    @State var currentPlayingVideoId: String?
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach($playlist.videos) { $video in
                    VideoView2(video: $video, 
                               likedCounter: $likedCounter,
                               isPlaying: $isPlaying,
                               currentPlayingVideoId: $currentPlayingVideoId,
                               size: size,
                               safeArea: safeArea)
                    .frame(maxHeight: .infinity)
                    .containerRelativeFrame(.horizontal)
                }
            }
        }
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.paging)
        .overlay(alignment: .bottom) {
            if !isPlaying {
                PostDetailsView()
                    .background(.black.opacity(0.7))
                    .opacity(isPlaying ? 0 : 1)
            }
        }
        .animation(.easeIn(duration: 0.8), value: isPlaying)
    }
    
    @ViewBuilder
    func dotNavigation() -> some View {
        let currentIndex = playlist.videos.firstIndex(where: { $0.id == currentPlayingVideoId })
        
        HStack(spacing: 10) {
            ForEach(0..<playlist.videos.count, id: \.self) { index in
                if currentIndex == index {
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
    
    @ViewBuilder
    func PostDetailsView() -> some View {
        VStack {
            dotNavigation()
            Spacer()
            HStack(alignment: .bottom, spacing: 10) {
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text(playlist.title)
                        .font(.H4)
                        .lineLimit(2)
                        .clipped()
                    
                    // Author details
                    HStack(spacing: 10) {
                        Image(systemName: "person.circle.fill")
                            .font(.title)
                        
                        Text(playlist.authorUsername)
                            .font(.subtitle1)
                            .lineLimit(1)
                            .clipped()
                    }
                    .foregroundStyle(.white)
                    
                    Text(playlist.description)
                        .font(.body1)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .clipped()
                }
                
                Spacer(minLength: 0)
                
                // Controls
                VStack(spacing: 32) {
                    
                    Button {
                        playlist.isLiked.toggle()
                    } label: {
                        Image(systemName: playlist.isLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
                    }
                    .symbolEffect(.bounce, value: playlist.isLiked)
                    .foregroundStyle(playlist.isLiked ? Color.primaryPurpleLight : .white)
                    
                    Button {
                    } label: {
                        Image(systemName: "hand.thumbsdown")
                    }
                    
                    Button {
                        // isShareShowing.toggle()
                    } label: {
                        Image(systemName: "paperplane")
                    }
                }
                .font(.title2)
                .foregroundColor(.white)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .padding(.top, safeArea.top + 12)
        .padding(.leading, safeArea.leading + 18)
        .padding(.trailing, safeArea.trailing + 18)
        .padding(.bottom, safeArea.bottom + 18)
    }
}

#Preview {
    ContentView()
}
