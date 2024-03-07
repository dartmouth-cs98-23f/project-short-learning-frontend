//
//  TestVideo.swift
//  Discite
//
//  Created by Jessie Li on 3/3/24.
//

import SwiftUI
import AVKit

struct TestVideo: View {
    var body: some View {
        VideoPlayer(player: AVPlayer(url: URL(string: "http://52.7.174.166/iwillsurvive/iwillsurvive.m3u8")!))
    }
}

#Preview {
    TestVideo()
}
