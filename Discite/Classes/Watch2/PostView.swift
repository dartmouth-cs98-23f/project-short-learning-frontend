//
//  PostView.swift
//  Discite
//
//  Created by Jessie Li on 2/13/24.
//

import SwiftUI
import AVKit

struct PostView: View {
    @Binding var playlist: Playlist
    @Binding var likedCounter: [Like]
    
    var size: CGSize
    var safeArea: EdgeInsets
    
    @State var player: AVPlayer?
    @State var looper: AVPlayerLooper?
    @State var isPlaying: Bool = false
    
    var body: some View {
        GeometryReader {
            let rect = $0.frame(in: .scrollView(axis: .vertical))
            
            CustomVideoPlayer2(player: $player)
                // details and controls, show only if paused
                .overlay(alignment: .bottom) {
                    if !isPlaying {
                        PostDetailsView()
                            .background(.black.opacity(0.7))
                            .opacity(isPlaying ? 0 : 1)
                    }
                }
                .animation(.easeIn(duration: 0.8), value: isPlaying)
                // offset updates
                .preference(key: OffsetKey.self, value: rect)
                .onPreferenceChange(OffsetKey.self, perform: { value in
                    playPause(value)
                })
                // liking the video
                .onTapGesture(count: 2, perform: { position in
                    let id = UUID()
                    likedCounter.append(.init(id: id, tappedRect: position, isAnimated: false))
                    
                    withAnimation(.snappy(duration: 2), completionCriteria: .logicallyComplete) {
                        if let index = likedCounter.firstIndex(where: { $0.id == id }) {
                            likedCounter[index].isAnimated = true
                        }
                    } completion: {
                        likedCounter.removeAll(where: { $0.id == id })
                    }
                    
                    playlist.isLiked = true
                })
                // playing/pausing on tap
                .onTapGesture {
                    switch player?.timeControlStatus {
                    case .paused:
                        player?.play()
                        isPlaying = true
                    case .waitingToPlayAtSpecifiedRate:
                        break
                    case .playing:
                        player?.pause()
                        isPlaying = false
                    case .none:
                        break
                    @unknown default:
                        break
                    }
                }
                // populating the player
                .onAppear {
                    guard player == nil else { return }
                    
                    guard
                        let video = playlist.currentVideo(),
                        let videoURL = URL(string: video.videoURL)
                    else { return }
                    
                    let playerItem = AVPlayerItem(url: videoURL)
                    let queue = AVQueuePlayer(playerItem: playerItem)
                    looper = AVPlayerLooper(player: queue, templateItem: playerItem)
                    player = queue
                    
                }
                // clearing the player
                .onDisappear {
                    player = nil
                }
        }
    }
    
    func playPause(_ rect: CGRect) {
        if -rect.minY < (rect.height * 0.5) && rect.minY < (rect.height * 0.5) {
            player?.play()
            isPlaying = true

        } else {
            player?.pause()
            isPlaying = false
        }
        
        if rect.minY >= size.height || -rect.minY >= size.height {
            player?.seek(to: .zero)
        }
    }
    
    @ViewBuilder
    func PostDetailsView() -> some View {
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
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .padding(.leading, safeArea.leading + 18)
        .padding(.trailing, safeArea.trailing + 18)
        .padding(.bottom, safeArea.bottom + 18)
    }
    
}

#Preview {
    ContentView()
}
