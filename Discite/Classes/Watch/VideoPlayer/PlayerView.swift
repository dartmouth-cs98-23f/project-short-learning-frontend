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
        
        if sequence.isLoading {
            Loading()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.primaryBlueBlack)
            
        } else {
            VideoPlayer(player: sequence.player)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    print("Player appear, reload.")
                    
                    if sequence.playlists.isEmpty {
                        print("Sequence is empty.")
                    }

                    addVideoEndedNotification()
                    
                    sequence.player.play()
                }
                .onDisappear {
                    print("Player disappear.")
                    sequence.player.pause()
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
                            sequence.nextVideo(swipeDirection: .right)
                            addVideoEndedNotification()
                            
                        case .left:
                            print("Swiped left to skip current playlist.")
                            // Skip current playlist
                            removeVideoEndedNotification()
                            sequence.nextVideo(swipeDirection: .left)
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

#Preview {
    let sequence = Sequence()
    
    return PlayerView()
        .environmentObject(sequence)
}
