//
//  PlayerView.swift
//  Discite
//
//  Created by Jessie Li on 11/3/23.
//

import SwiftUI
import AVKit

struct PlayerView: View {
    @ObservedObject var sequence: Sequence
    @State private var showingDeepDive = false
    
    var body: some View {

        if sequence.playerItem == nil {
            Loading()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.primaryBlueBlack)
            
        } else {
            VideoPlayer(player: sequence.player)
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
                        case .right:
                            print("Swiped right, next video.")
                        
                        case .left:
                            print("Swiped left to skip current playlist.")
                            removeVideoEndedNotification()

                            Task {
                                await sequence.load()
                                print("Replaced context's player.")
                                play()
                            }
                            
                        default:
                            print("No action required.")
                        }
                    })
                )
        }
        
    }
    
    func play() {
        addVideoEndedNotification()
        sequence.player.play()
    }
    
    func pause() {
        removeVideoEndedNotification()
        sequence.player.pause()
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
