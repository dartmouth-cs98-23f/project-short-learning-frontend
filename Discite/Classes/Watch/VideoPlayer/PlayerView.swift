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
    @State private var showingDeepDive = false
    
    var body: some View {
        
        if sequence.isLoading || sequence.player.currentItem == nil {
            Loading()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.primaryBlueBlack)
            
        } else {
            VideoPlayer(player: sequence.player)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    print("Player appeared.")
                    addVideoEndedNotification()
                    sequence.player.play()
                }
                .onDisappear {
                    print("Player disappeared.")
                    sequence.player.pause()
                    removeVideoEndedNotification()
                }
                .gesture(DragGesture(minimumDistance: 10)
                    .onEnded({ value in
                        let swipeDirection = swipeDirection(value: value)
                        
                        switch swipeDirection {
                        case .right:
                            print("Swiped right for next video.")
                            // Move to the next video
                            removeVideoEndedNotification()
                            sequence.next(swipeDirection: .right)
                            addVideoEndedNotification()
                            
                        case .left:
                            print("Swiped left to skip current playlist.")
                            // Skip current playlist
                            removeVideoEndedNotification()
                            sequence.next(swipeDirection: .left)
                            addVideoEndedNotification()
                            
                        case .up:
                            // Show DeepDive
                            sequence.player.pause()
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

    }
    
    func deepDiveDismissed() {
        sequence.player.play()
    }
    
    func removeVideoEndedNotification() {
        NotificationCenter
            .default
            .removeObserver(self,
                            name: .AVPlayerItemDidPlayToEndTime,
                            object: sequence.player.currentItem)
    }
    
    func addVideoEndedNotification() {
        NotificationCenter
            .default
            .addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                         object: sequence.player.currentItem,
                         queue: .main) { (_) in
                
                sequence.player.seek(to: .zero)
                sequence.player.play()
            }
    }
    
}
