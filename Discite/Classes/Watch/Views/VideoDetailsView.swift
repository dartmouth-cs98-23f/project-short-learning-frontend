//
//  VideoDetailsView.swift
//  Discite
//
//  Created by Jessie Li on 3/2/24.
//

import SwiftUI
import AVKit
import UIKit

struct VideoDetailsView: View {
    @ObservedObject var playlist: Playlist
    @ObservedObject var video: Video
    
    @Binding var player: AVPlayer?
    
    @State var didDislike: Bool = false
    @State var isShareShowing: Bool = false
    @State var isPlaying: Bool
    
    var safeArea: EdgeInsets
    private let alertTitle = "Disliked?"
    
    init(playlist: Playlist, video: Video, player: Binding<AVPlayer?>, safeArea: EdgeInsets) {
        self.playlist = playlist
        self.video = video
        self.safeArea = safeArea
        self._player = player
        self._isPlaying =  State(initialValue: player.wrappedValue?.timeControlStatus == .playing)
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 12) {
                    dotNavigation()
                    
                    Spacer()
                    
                    HStack(alignment: .bottom, spacing: 10) {
                        VStack(alignment: .leading, spacing: 10) {
                            Button {
                                openYouTube()
                            } label: {
                                HStack(spacing: 4) {
                                    Text("Open in YouTube")
                                    Image(systemName: "arrow.right")
                                }
                            }
                            .font(.small)
                            .foregroundStyle(Color.secondaryPurplePinkLight)
                            
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
                            
                            if geo.size.height > 400 {
                                Text(playlist.description)
                                    .font(.body1)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                                    .clipped()
                            }
                        }
                        
                        Spacer(minLength: 0)
                        
                        // Controls
                        controls()
                    }
                    
                    NavigationBar()
                }
                
                playBackControls()
                    .frame(maxWidth: 200)
                    .padding(.horizontal, 64)
            }
        }
        .sheet(isPresented: $isShareShowing) {
            Share(playlist: playlist, isShowing: $isShareShowing)
        }
        .alert(
            alertTitle,
            isPresented: $didDislike
        ) {
            Button("Too easy") {
                Task { await video.postUnderstanding(understand: true) }
            }
            
            Button("Too hard") {
                Task { await video.postUnderstanding(understand: false) }
            }
            
        } message: {
            Text("Tell us why you disliked this video.")
        }
        .padding(.top, safeArea.top + 4)
        .padding(.leading, safeArea.leading + 18)
        .padding(.trailing, safeArea.trailing + 18)
        .padding(.bottom, safeArea.bottom)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.7))
    }
    
    // Function to skip ahead/go back in the video
    private func skipTime(seconds: Double) {
        guard let player = player else { return }
            
        // Calculate the new time
        let currentTime = player.currentTime()
        let newTime = CMTime(seconds: currentTime.seconds + seconds, preferredTimescale: currentTime.timescale)

        // Seek to the new time
        player.seek(to: newTime)
    }
    
    @ViewBuilder
    func playBackControls() -> some View {
        HStack {
            Button {
                skipTime(seconds: 10)
            } label: {
                Image(systemName: "arrow.counterclockwise")
            }
            
            Spacer()
            
            Button {
                if isPlaying {
                    player?.pause()
                } else {
                    player?.play()
                }
    
                isPlaying.toggle()
                
            } label: {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
            }
        
            Spacer()
            
            Button {
                skipTime(seconds: -10)
            } label: {
                Image(systemName: "arrow.clockwise")
            }
        }
        .foregroundStyle(Color.white)
        .font(.largeTitle)
    }
    
    @ViewBuilder
    func controls() -> some View {
        VStack(spacing: 32) {
            
            Button {
                playlist.isSaved.toggle()
                
                Task {
                    playlist.isSaved
                    ? await playlist.postSave()
                    : await playlist.deleteSave()
                }
                
            } label: {
                Image(systemName: playlist.isSaved ? "bookmark.fill" : "bookmark")
            }
            .symbolEffect(.bounce, value: video.isLiked)
            .foregroundStyle(playlist.isSaved ? Color.primaryPurpleLight : .white)
            
            Button {
                playlist.isDisliked = false
                playlist.isLiked.toggle()
                
                Task {
                    playlist.isLiked
                    ? await playlist.postLike()
                    : await playlist.deleteLike()
                }
                
            } label: {
                Image(systemName: playlist.isLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
            }
            .symbolEffect(.bounce, value: playlist.isLiked)
            .foregroundStyle(playlist.isLiked ? Color.primaryPurpleLight : .white)
            
            Button {
                playlist.isLiked = false
                playlist.isDisliked.toggle()
                
                if playlist.isDisliked { didDislike = true }
                
                Task {
                    playlist.isDisliked
                    ? await playlist.postDislike()
                    : await playlist.deleteDislike()
                }
                
            } label: {
                Image(systemName: playlist.isDisliked ? "hand.thumbsdown.fill" : "hand.thumbsdown")
            }
            .symbolEffect(.bounce, value: playlist.isDisliked)
            .foregroundStyle(playlist.isDisliked ? Color.red : .white)
            
            Button {
                isShareShowing = true
                print("pressed share")
            } label: {
                Image(systemName: "paperplane")
            }
        }
        .font(.title2)
        .foregroundColor(.white)
    }
    
    @ViewBuilder
    func dotNavigation() -> some View {
        let currentIndex = playlist.videos.firstIndex(where: { $0.id == video.id })
        
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
    
    private func openYouTube() {
        // if let youtubeURL = URL(string: "youtube://\(playlist.youtubeId)"),
        if let youtubeURL = URL(string: "youtube://www.youtube.com"),
            UIApplication.shared.canOpenURL(youtubeURL) {
            // Open in YouTube app if installed
            print("Opening YouTube App.")
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
            
        // } else if let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(playlist.youtubeId)") {
        } else if let youtubeURL = URL(string: "https://www.youtube.com") {
            // Open in Safari if YouTube app is not installed
            print("Opening YouTube in Safari.")
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
        }

    }
}
