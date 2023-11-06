//
//  TestSimplePlayerView.swift
//  Discite
//
//  Created by Jessie Li on 10/27/23.
//

import SwiftUI
import AVKit

struct TestSimplePlayerView: View {
    private let queuePlayer = AVQueuePlayer()
    private let player = AVPlayer(url: Bundle.main.url(forResource: "video1", withExtension: "mp4")!)
    
    var body: some View {
        VideoPlayer(player: player)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                player.play()
            }
            .onDisappear {
                player.pause()
            }
    }
}

struct TestSimplePlayerView_Previews: PreviewProvider {
    static var previews: some View {
        TestSimplePlayerView()
    }
}
