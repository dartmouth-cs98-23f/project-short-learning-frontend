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
    @State var shareShowing: Bool = false
    @State var detailsShowing: Bool = false
    @State var isPlaying: Bool
    
    private var safeArea: EdgeInsets
    private let alertTitle = "Tell us why you disliked this video."

    init(playlist: Playlist, 
         video: Video,
         player: Binding<AVPlayer?>,
         safeArea: EdgeInsets
    ) {
       
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
                                .foregroundStyle(Color.secondaryPeachLight)
                                .clipped()
                            
                            if geo.size.height > 400 {
                                Text(playlist.description ?? "")
                                    .font(.body1)
                                    .foregroundStyle(Color.grayLight)
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
        .sheet(isPresented: $shareShowing) {
            Share(playlist: playlist, isShowing: $shareShowing)
        }
        .sheet(isPresented: $detailsShowing) {
            PlaylistSummaryView(playlist: playlist)
        }
        .alert(alertTitle, isPresented: $didDislike) {
            Button("Too easy") {
                Task { await video.postUnderstanding(understand: true) }
            }
            
            Button("Too difficult") {
                Task { await video.postUnderstanding(understand: false) }
            }
            
        } message: {
            Text("Help us improve our recommendations by telling us why this video wasn't right for you.")
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
    private func controls() -> some View {
        VStack(spacing: 32) {
            saveButton()
            likeButton()
            dislikeButton()
            shareButton()
            detailsButton()
        }
        .font(.title2)
        .foregroundStyle(Color.secondaryPeachLight)
    }
    
    @ViewBuilder
    private func dotNavigation() -> some View {
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
    
    @ViewBuilder
    private func saveButton() -> some View {
        Button {
            playlist.isSaved.toggle()
            Task {
                playlist.isSaved
                ? await playlist.postSave()
                : await playlist.deleteSave()
            }
        } label: {
            Image(systemName: playlist.isSaved
                  ? "bookmark.fill"
                  : "bookmark")
        }
        .foregroundStyle(playlist.isSaved
                         ? Color.primaryPurpleLight
                         : Color.secondaryPeachLight)
    }
    
    @ViewBuilder
    private func likeButton() -> some View {
        Button {
            playlist.isDisliked = false
            playlist.isLiked.toggle()
            
            Task {
                playlist.isLiked
                ? await playlist.postLike()
                : await playlist.deleteLike()
            }
            
        } label: {
            Image(systemName: playlist.isLiked
                  ? "hand.thumbsup.fill"
                  : "hand.thumbsup")
        }
        .symbolEffect(.bounce, value: playlist.isLiked)
        .foregroundStyle(playlist.isLiked
                         ? Color.primaryPurpleLight
                         : Color.secondaryPeachLight)
    }
    
    @ViewBuilder
    private func dislikeButton() -> some View {
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
            Image(systemName: playlist.isDisliked
                  ? "hand.thumbsdown.fill"
                  : "hand.thumbsdown")
        }
        .symbolEffect(.bounce, value: playlist.isDisliked)
        .foregroundStyle(playlist.isDisliked
                         ? Color.red
                         : Color.secondaryPeachLight)
    }
    
    @ViewBuilder
    private func shareButton() -> some View {
        Button {
            shareShowing = true
        } label: {
            Image(systemName: "paperplane")
        }
    }
    
    @ViewBuilder
    private func detailsButton() -> some View {
        Button {
            detailsShowing = true
        } label: {
            Image(systemName: "ellipsis")
        }
    }
    
    private func openYouTube() {
        // if let youtubeURL = URL(string: "youtube://\(playlist.youtubeId)"),
        let youtubeLink = playlist.youtubeURL != nil ? playlist.youtubeURL! : "www.youtube.com"
           
        if let youtubeURL = URL(string: "youtube://\(youtubeLink)"),
            UIApplication.shared.canOpenURL(youtubeURL) {
            // Open in YouTube app if installed
            print("Opening YouTube App.")
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
            
        // } else if let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(playlist.youtubeId)") {
        } else if let youtubeURL = URL(string: "https://\(youtubeLink)") {
            // Open in Safari if YouTube app is not installed
            print("Opening YouTube in Safari.")
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
        }

    }
}

#Preview {
    @State var player: AVPlayer?
    let video = Video()
    let playlist = Playlist()
    
    return GeometryReader {
        let size = $0.size
        let safeArea = $0.safeAreaInsets
        
        VideoDetailsView(playlist: playlist,
                         video: video,
                         player: $player,
                         safeArea: safeArea)
        .ignoresSafeArea(.container, edges: .all)
        .environment(TabSelectionManager(selection: .Watch))
    }
}
