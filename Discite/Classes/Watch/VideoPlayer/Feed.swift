//
//  Feed.swift
//  Discite
//
//  Created by Jessie Li on 1/21/24.
//
//  https://medium.com/whatnot-engineering/the-next-page-8950875d927a

import SwiftUI
import AVKit

struct Feed: View {
    @ObservedObject var viewModel = SequenceViewModel()
    
    @State private var player = AVPlayer()
    @State private var scrollPosition: String?
    
    var body: some View {
        
        if viewModel.items.count == 0, case .error = viewModel.state {
            Text("Error loading content.")
            
        } else if viewModel.items.count == 0 {
            ProgressView()
            
        } else {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.items) { item in
                        Post(playlist: item, player: player)
                            .id(item.id)
                            .onAppear {
                                viewModel.onItemAppear(playlist: item)
                            }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $scrollPosition)
            .ignoresSafeArea()
            .onChange(of: scrollPosition) { _, new in
                updatePlayer(id: new)
                if self.player.rate == 0 && self.player.error == nil {
                    player.play()
                }
            }
        }
    }
    
    func updatePlayer(id: String?) {
        guard
            let currentPost = viewModel.items.first(where: { $0.id == id }),
            let playerItem = currentPost.currentVideo()?.getPlayerItem()
        else {
            return
        }
                
        player.replaceCurrentItem(with: nil)
        player.replaceCurrentItem(with: playerItem)
    }
}

#Preview {
    Feed()
}
