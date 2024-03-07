//
//  PostView.swift
//  Discite
//
//  Created by Jessie Li on 2/13/24.
//

import SwiftUI

struct PlaylistView: View {
    @ObservedObject var viewModel: SequenceViewModel
    @ObservedObject var playlist: Playlist
    @Binding var likedCounter: [Like]
    
    var size: CGSize
    var safeArea: EdgeInsets
    var includeNavigation: Bool = true
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(playlist.videos) { video in
                    VideoView(viewModel: viewModel,
                              playlist: playlist,
                              video: video,
                              likedCounter: $likedCounter,
                              size: size,
                              safeArea: safeArea,
                              includeNavigation: includeNavigation)
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
