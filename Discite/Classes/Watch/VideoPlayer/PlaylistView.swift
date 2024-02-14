//
//  PostView.swift
//  Discite
//
//  Created by Jessie Li on 2/13/24.
//

import SwiftUI

struct PlaylistView: View {
    @ObservedObject var playlist: Playlist
    @Binding var likedCounter: [Like]
    
    var size: CGSize
    var safeArea: EdgeInsets
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(playlist.videos) { video in
                    VideoView(playlist: playlist,
                               video: video,
                               likedCounter: $likedCounter,
                               size: size,
                               safeArea: safeArea)
                    .frame(maxHeight: .infinity)
                    .containerRelativeFrame(.horizontal)
                }
            }
        }
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.paging)
        
    }
}

#Preview {
    ContentView()
}
