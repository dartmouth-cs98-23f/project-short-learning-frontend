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
        Button {
            sequence.fetchNextSequence()
        } label: {
            Text("Fetch next sequence")
        }
        
        VideoPlayer(player: sequence.getCurrentPlayer())
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                sequence.play()
                
            }
            .onDisappear {
                sequence.pause()
    
            }
            .gesture(DragGesture(minimumDistance: 20)
                .onEnded({ value in
                    let swipeDirection = swipeDirection(value: value)
                    
                    switch swipeDirection {
                    case .right:
                        // Move to the next video
                        sequence.nextVideo(swipeDirection: .right)
                    
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
}

#Preview {
    PlayerView()
        .environmentObject(Sequence())
}
