//
//  VideoPlayerView.swift
//  Discite
//
//  Created by Jessie Li on 10/25/23.
//
//  Sources:
//      VideoPlayer: https://developer.apple.com/documentation/avkit/videoplayer
//      Swipe motion: https://developer.apple.com/documentation/swiftui/draggesture
//      Detect swiping: https://stackoverflow.com/questions/60885532/how-to-detect-swiping-up-down-left-and-right-with-swiftui-on-a-view
//      End of video notification (for looping): https://stackoverflow.com/questions/29386531/how-to-detect-when-avplayer-video-ends-playing

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    private let videoQueue = VideoQueue()
    
    var body: some View {
        
        VStack {
            Button("Fetch videos") {
                videoQueue.fetchVideos()
            }
            
            if videoQueue.fetchSuccessful {
                Text("Fetch was successful.")
            }
            
            VideoPlayer(player: videoQueue.player)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    videoQueue.player.play()
                    
                    NotificationCenter.default.addObserver(
                        forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                        object: videoQueue.player.currentItem,
                        queue: .main) { (_) in
                        
                        // Loop the video
                        videoQueue.player.seek(to: .zero)
                        videoQueue.player.play()
                    }
                }
                .onDisappear {
                    videoQueue.player.pause()
                }
                .gesture(DragGesture(minimumDistance: 20)
                    .onEnded({ value in
                        let swipeDirection = swipeDirection(value: value)
                        
                        switch swipeDirection {
                        case .right:
                            // Move to the next video
                            videoQueue.nextVideo()
                        default:
                            print("No action required.")
                        }
                    })
            )
        }
    }
}

struct VideoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayerView()
    }
}
