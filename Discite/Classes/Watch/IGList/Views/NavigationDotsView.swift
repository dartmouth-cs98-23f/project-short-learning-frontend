//
//  NavigationDotsView.swift
//  Discite
//
//  Created by Jessie Li on 3/7/24.
//

import SwiftUI

struct NavigationDotsView: View {
    let video: Video?
    
    var body: some View {
     //   if let video = video, let playlist = video.playlist {
            // let currentIndex = playlist.videos.firstIndex(where: { $0.id == video.id })
            let currentIndex = 1
            
            HStack(spacing: 10) {
                ForEach(0..<3, id: \.self) { index in
                // ForEach(0..<playlist.videos.count, id: \.self) { index in
                    if currentIndex == index {
                        Circle()
                            .fill(Color.primaryPurpleLightest.opacity(1))
                            .frame(width: 12, height: 12)
                    } else {
                        Circle()
                            .fill(Color.primaryPurpleLight.opacity(0.5))
                            .frame(width: 8, height: 8)
                    }
                }
            }
      //  }
    }
}

#Preview {
    NavigationDotsView(video: Video())
}
