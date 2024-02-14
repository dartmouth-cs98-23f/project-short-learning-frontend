//
//  VideoView.swift
//  Discite
//
//  Created by Jessie Li on 2/14/24.
//

import SwiftUI
import AVKit

struct VideoView: View {
    @ObservedObject var playlist: Playlist
    @ObservedObject var video: Video
    @Binding var likedCounter: [Like]

    var size: CGSize
    var safeArea: EdgeInsets
    
    @State var player: AVPlayer?
    @State var looper: AVPlayerLooper?
    @State var isPlaying: Bool = false
    
    @State var isShareShowing = false
    
    var body: some View {
        GeometryReader {
            let rect = $0.frame(in: .scrollView(axis: .vertical))
            
            CustomVideoPlayer(player: $player)
                // share sheet
                .sheet(isPresented: $isShareShowing) {
                    Share(playlist: playlist, isShowing: $isShareShowing)
                }
                
                // details and controls, only show on pause
                .overlay(alignment: .bottom) {
                    if !isPlaying {
                        PostDetailsView()
                            .background(.black.opacity(0.7))
                            .opacity(isPlaying ? 0 : 1)
                    }
                }
                .animation(.easeIn(duration: 0.3), value: isPlaying)
                
                // offset updates
                .preference(key: OffsetKey.self, value: rect)
                .onPreferenceChange(OffsetKey.self, perform: { value in
                    playPause(value)
                })
                
                // liking the video
                .onTapGesture(count: 2, perform: { _ in
                    print("double tap")
                    let id = UUID()
                    likedCounter.append(.init(id: id, isAnimated: false))
                    
                    withAnimation(.snappy(duration: 2), completionCriteria: .logicallyComplete) {
                        if let index = likedCounter.firstIndex(where: { $0.id == id }) {
                            likedCounter[index].isAnimated = true
                        }
                    } completion: {
                        likedCounter.removeAll(where: { $0.id == id })
                    }
                    
                    video.isLiked = true
                })
                
                // playing/pausing on tap
                .onTapGesture {
                    switch player?.timeControlStatus {
                    case .paused:
                        play()
                    case .waitingToPlayAtSpecifiedRate:
                        break
                    case .playing:
                        pause()
                    case .none:
                        break
                    @unknown default:
                        break
                    }
                }
                
                // populating the player
                .onAppear {
                    guard player == nil else { return }
                    
                    guard let videoURL = URL(string: video.videoURL) else { return }
                    
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
    
    func play() {
        player?.play()
        isPlaying = true
    }
    
    func pause() {
        player?.pause()
        isPlaying = false
    }
    
    func playPause(_ rect: CGRect) {
        if -rect.minY < (rect.height * 0.5) && rect.minY < (rect.height * 0.5) {
            play()

        } else {
           pause()
        }
        
        if rect.minY >= size.height || -rect.minY >= size.height {
            player?.seek(to: .zero)
        }
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
    
    @ViewBuilder
    func controls() -> some View {
        VStack(spacing: 32) {
            
            Button {
                video.isLiked.toggle()
            } label: {
                Image(systemName: video.isLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
            }
            .symbolEffect(.bounce, value: video.isLiked)
            .foregroundStyle(video.isLiked ? Color.primaryPurpleLight : .white)
            
            Button {
            } label: {
                Image(systemName: "hand.thumbsdown")
            }
            
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
    func PostDetailsView() -> some View {
        VStack(spacing: 12) {
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
                controls()
            }
            
            NavigationBar()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .padding(.top, safeArea.top + 12)
        .padding(.leading, safeArea.leading + 18)
        .padding(.trailing, safeArea.trailing + 18)
        .padding(.bottom, safeArea.bottom)
    }

}

#Preview {
    ContentView()
}
