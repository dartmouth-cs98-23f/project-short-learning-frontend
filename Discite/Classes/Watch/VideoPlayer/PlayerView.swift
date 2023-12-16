//
//  PlayerView.swift
//  Discite
//
//  Created by Jessie Li on 11/3/23.
//

import SwiftUI
import AVKit

struct PlayerView: View {
    @EnvironmentObject var context: MyContext
    @State private var showingDeepDive = false
    
    var body: some View {
        
        if context.player.currentItem == nil {
            Loading()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.primaryBlueBlack)
            
        } else {
            VideoPlayer(player: context.player)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    print("Player appeared.")
                    play()
                }
                .onDisappear {
                    print("Player disappeared.")
                    pause()
                }
            
                .gesture(DragGesture(minimumDistance: 10)
                    .onEnded({ value in
                        let swipeDirection = swipeDirection(value: value)
                        
                        switch swipeDirection {
                        case .left:
                            print("Swiped left to skip current playlist.")
                            removeVideoEndedNotification()

                            Task {
                                await context.reloadPlaylists()
                                print("Replaced context's player.")
                                play()
                            }
                            
                        default:
                            print("No action required.")
                        }
                    })
                )
        }
        
//        if let sequence = context.sequence {
//            VideoPlayer(player: sequence.player)
//                .edgesIgnoringSafeArea(.all)
//                .onAppear {
//                    print("Player appeared.")
//                    addVideoEndedNotification()
//                    sequence.player.play()
//                }
//                .onDisappear {
//                    print("Player disappeared.")
//                    sequence.player.pause()
//                    removeVideoEndedNotification()
//                }
//                .gesture(DragGesture(minimumDistance: 10)
//                    .onEnded({ value in
//                        let swipeDirection = swipeDirection(value: value)
//                        
//                        switch swipeDirection {
//                        case .right:
//                            print("Swiped right for next video.")
//                            // Move to the next video
//                            removeVideoEndedNotification()
//                            sequence.next(swipeDirection: .right)
//                            addVideoEndedNotification()
//                            
//                        case .left:
//                            print("Swiped left to skip current playlist.")
//                            // Skip current playlist
//                            removeVideoEndedNotification()
//                            // sequence.next(swipeDirection: .left)
//                            
//                            Task {
//                                do {
//                                    context.sequence = try await VideoService.loadSequence()
//                                    addVideoEndedNotification()
//                                    context.sequence.player.play()
//                                    
//                                } catch {
//                                    print("Failed to load a new sequence.")
//                                }
//                            }
//                            
//                        case .up:
//                            // Show DeepDive
//                            sequence.player.pause()
//                            showingDeepDive = true
//                            
//                        default:
//                            print("No action required.")
//                        }
//                    })
//                )
//                .sheet(isPresented: $showingDeepDive, onDismiss: deepDiveDismissed, content: {
//                    let currentPlaylist = sequence.currentPlaylist()
//                    if currentPlaylist != nil {
//                        DeepDive(playlist: currentPlaylist!, isPresented: $showingDeepDive)
//                    } else {
//                        Text("No DeepDive to show.")
//                    }
//                })
//            
//        } else {
//            Loading()
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .background(Color.primaryBlueBlack)
//        }

    }
    
//    func deepDiveDismissed() {
//        sequence.player.play()
//    }
    
    func play() {
        addVideoEndedNotification()
        context.player.play()
    }
    
    func pause() {
        removeVideoEndedNotification()
        context.player.pause()
    }
    
    func removeVideoEndedNotification() {
        NotificationCenter
            .default
            .removeObserver(self,
                            name: .AVPlayerItemDidPlayToEndTime,
                            object: context.player.currentItem)
    }
    
    func addVideoEndedNotification() {
        NotificationCenter
            .default
            .addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                         object: context.player.currentItem,
                         queue: .main) { (_) in
                
                context.player.seek(to: .zero)
                context.player.play()
            }
    }
    
}
