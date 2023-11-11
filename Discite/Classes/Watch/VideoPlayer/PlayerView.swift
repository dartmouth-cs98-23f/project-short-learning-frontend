//
//  PlayerView.swift
//  Discite
//
//  Created by Jessie Li on 11/3/23.
//

import SwiftUI
import AVKit

struct PlayerView: View {
    @EnvironmentObject var sequence: Sequence
    
    @State var player: AVPlayer = AVPlayer()
    @State private var showingDeepDive = false
    
    var body: some View {
        VideoPlayer(player: player)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                print("Player appear, reload")
                player.replaceCurrentItem(with: sequence.currentVideo())
                addVideoEndedNotification()
                
                player.play()
            }
            .onDisappear {
                print("Player disappear")
                player.pause()
                removeVideoEndedNotification()
            }
            .gesture(DragGesture(minimumDistance: 20)
                .onEnded({ value in
                    let swipeDirection = swipeDirection(value: value)
                    
                    switch swipeDirection {
                    case .right:
                        print("Swiped right for next video.")
                        // Move to the next video
                        removeVideoEndedNotification()
                        let nextPlayerItem = sequence.nextVideo(swipeDirection: .right)
                        player.replaceCurrentItem(with: nextPlayerItem)
                        addVideoEndedNotification()
                        
                    case .left:
                        print("Swiped left to skip current playlist.")
                        // Skip current playlist
                        removeVideoEndedNotification()
                        let nextPlayerItem = sequence.nextVideo(swipeDirection: .left)
                        player.replaceCurrentItem(with: nextPlayerItem)
                        addVideoEndedNotification()
                    
                    case .up:
                        // Show DeepDive
                        player.pause()
                        showingDeepDive = true
                        
                    default:
                        print("No action required.")
                    }
                })
            )
            .sheet(isPresented: $showingDeepDive, onDismiss: deepDiveDismissed, content: {
                let currentPlaylist = sequence.currentPlaylist()
                if currentPlaylist != nil {
                    DeepDive(playlist: currentPlaylist!, isPresented: $showingDeepDive)
                } else {
                    Text("No DeepDive to show.")
                }
            })

    }
    
    func deepDiveDismissed() {
        player.play()
    }
    
    func removeVideoEndedNotification() {
        NotificationCenter
            .default
            .removeObserver(self,
                            name: .AVPlayerItemDidPlayToEndTime,
                            object: player.currentItem)
    }
    
    func addVideoEndedNotification() {
        NotificationCenter
            .default
            .addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                         object: player.currentItem,
                         queue: .main) { (_) in
                
                player.seek(to: .zero)
                player.play()
            }
    }
    
}

#Preview {
    let sequence = VideoService.fetchTestSequence(topicId: nil)
    
    if sequence != nil {
        return PlayerView()
            .environmentObject(sequence!)
    } else {
        return Text("Error occurred while fetching test sequence.")
    }
}
