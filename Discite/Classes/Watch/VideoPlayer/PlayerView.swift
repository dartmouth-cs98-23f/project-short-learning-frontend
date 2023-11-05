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
    
    @State var player = AVPlayer()
    @State private var showingDeepDive = false
    
    var body: some View {
        VStack {
            Button {
                sequence.fetchNextSequence()
            } label: {
                Text("Fetch next sequence")
            }
            
            VideoPlayer(player: player)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    player.play()
                    addVideoEndedNotification()
                    
                    if player.currentItem == nil {
                        sequence.nextVideo(swipeDirection: .right, player: player)
                        player.play()
                    }
                    
                }
                .onDisappear {
                    player.pause()
        
                }
                .gesture(DragGesture(minimumDistance: 20)
                    .onEnded({ value in
                        let swipeDirection = swipeDirection(value: value)
                        
                        switch swipeDirection {
                        case .right:
                            // Move to the next video
                            removeVideoEndedNotification()
                            sequence.nextVideo(swipeDirection: .right, player: player)
                        
                        case .up:
                            // Show DeepDive
                            // videoQueue.player.pause()
                            showingDeepDive = true
                            
                        default:
                            print("No action required.")
                        }
                    })
                )
        }
        .sheet(isPresented: $showingDeepDive) {
            DeepDiveView(isPresented: $showingDeepDive)
        }

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
    PlayerView()
        .environmentObject(Sequence())
}
