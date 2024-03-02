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
    @State var error: Error?
    @State var showOverlay: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            let rect = geo.frame(in: .scrollView(axis: .horizontal))
            let shouldPlay = isMainView(rect)
            
            CustomVideoPlayer(player: $player)

                // details and controls, only show on pause
                .overlay(alignment: .bottom) {
                    if showOverlay {
                        VideoDetailsView(
                            playlist: playlist,
                            video: video,
                            player: $player,
                            safeArea: safeArea
                        )
                    }
                }
                .animation(.easeIn(duration: 0.3), value: showOverlay)
            
                // offset updates
                .preference(key: VisibleKey.self, value: shouldPlay)
                .onPreferenceChange(VisibleKey.self, perform: { value in
                    playPause(shouldPlay: value)
                    
                    if !shouldPlay, let currentTime = player?.currentTime() {
                        let timestamp = CMTimeGetSeconds(currentTime)
                        Task { await video.postTimestamp(timestamp: timestamp) }
                    }
                })
            
                // liking the video
                .onTapGesture(count: 2, perform: { _ in
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
                    showOverlay.toggle()
                }
            
                // populating the player
                .onAppear {
                    guard player == nil else { return }
                    
                    guard let videoURL = URL(string: video.videoURL) else { return }
                    
                    let playerItem = AVPlayerItem(url: videoURL)
                    let queue = AVQueuePlayer(playerItem: playerItem)
                    looper = AVPlayerLooper(player: queue, templateItem: playerItem)
                    player = queue
                    
                    if shouldPlay {
                        player?.play()
                        isPlaying = true
                    }
                }
            
                // clearing the player
                .onDisappear {
                    player = nil
                }
        }
    }
    
    func isMainView(_ rect: CGRect) -> Bool {
        let mainVertical = -rect.minY < (rect.height * 0.5) && rect.minY < (rect.height * 0.5)
        let mainHorizontal = -rect.minX < (rect.width * 0.5) && rect.minX < (rect.width * 0.5)
        
        return mainVertical && mainHorizontal
    }
    
    func play() {
        if !isPlaying {
            print("play \(video.id)")
            player?.play()
            isPlaying = true
        }
    }
    
    func pause() {
        if isPlaying {
            print("pause \(video.id)")
            player?.pause()
            isPlaying = false
        }
    }
    
    func playPause(shouldPlay: Bool) {
        if shouldPlay {
            play()

        } else {
            pause()
            player?.seek(to: .zero)
        }
    }
}

#Preview {
    ContentView()
}
