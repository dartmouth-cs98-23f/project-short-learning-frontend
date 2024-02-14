//
//  VideoView2.swift
//  Discite
//
//  Created by Jessie Li on 2/13/24.
//

import SwiftUI
import AVKit

struct VideoView2: View {
    @Binding var video: Video
    @Binding var likedCounter: [Like]
    @Binding var isPlaying: Bool
    @Binding var currentPlayingVideoId: String?

    var size: CGSize
    var safeArea: EdgeInsets
    
    @State var player: AVPlayer?
    @State var looper: AVPlayerLooper?
    
    var body: some View {
        GeometryReader {
            let rect = $0.frame(in: .scrollView(axis: .vertical))
            
            CustomVideoPlayer2(player: $player)
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
                    
                    video.isLiked = true
                })
                // playing/pausing on tap
                .onTapGesture {
                    switch player?.timeControlStatus {
                    case .paused:
                        print("was paused, now playing")
                        play()
                    case .waitingToPlayAtSpecifiedRate:
                        break
                    case .playing:
                        print("was playing, now paused")
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
        currentPlayingVideoId = video.id
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

}

#Preview {
    ContentView()
}
