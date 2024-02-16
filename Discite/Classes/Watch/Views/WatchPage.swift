//
//  WatchPage.swift
//  Discite
//
//  Created by Jessie Li on 2/13/24.
//

import SwiftUI

struct WatchPage: View {
    var size: CGSize
    var safeArea: EdgeInsets
    var seedPlaylist: PlaylistPreview? 

    @StateObject var viewModel = SequenceViewModel()
    @State var likedCounter: [Like] = []
    
    var body: some View {
        if case .error = viewModel.state {
            Text("Error loading content.")

        } else if viewModel.items.isEmpty {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tint(.white)
                .background(.black)
                .animation(.easeOut(duration: 0.1), value: viewModel.items.isEmpty)
                .task {
                   await viewModel.load()
                }
            
        } else {
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.items) { item in
                        PlaylistView(playlist: item,
                                     likedCounter: $likedCounter,
                                     size: size,
                                     safeArea: safeArea)
                        .frame(maxWidth: .infinity)
                        .containerRelativeFrame(.vertical)
                        .onAppear {
                            viewModel.onItemAppear(playlist: item)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
            .background(.black)
            
            // like animation
            .overlay(alignment: .topLeading) {
                ZStack {
                    ForEach(likedCounter) { like in
                        Image(systemName: "hand.thumbsup.fill")
                            .font(.system(size: 72))
                            .addGradient(gradient: .pinkOrangeGradient)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .opacity(like.isAnimated ? 1 : 0)
                            .scaleEffect(like.isAnimated ? 0.5 : 1)
                            .animation(.smooth(duration: 1.5), value: like.isAnimated)
                    }
                }
            }
            .environment(\.colorScheme, .dark)
        }
    }
}

#Preview {
    ContentView()
}
