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

    @StateObject var viewModel = SequenceViewModel()
    @State var likedCounter: [Like] = []
    
    var body: some View {
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

#Preview {
    ContentView()
}
