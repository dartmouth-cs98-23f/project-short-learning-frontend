//
//  Paging.swift
//  Discite
//
//  Created by Jessie Li on 1/21/24.
//
//  https://medium.com/whatnot-engineering/the-next-page-8950875d927a

import SwiftUI
import AVKit

struct Paging: View {
    @ObservedObject var viewModel = SequenceNew()
    
    @State private var player = AVPlayer()
    @State private var scrollPosition: String?
    
    var body: some View {
        
        if viewModel.items.count == 0 {
            ProgressView()
            
        } else {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.items) { item in
                        Post(playlist: item, player: player)
                            .id(item.id)
                            .onAppear {
                                viewModel.onItemAppear(playlist: item)
                                initialPlay()
                            }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $scrollPosition)
            .ignoresSafeArea()
            .onAppear {
                player.play()
            }
            .onChange(of: scrollPosition) { _, new in
                print("DEBUG: Scroll position now at \(new ?? "undefined").")
                updatePlayer(id: new)
            }
        }
    }
    
    // When Watch first launches, manually play first video
    func initialPlay() {
        guard 
            scrollPosition == nil,
            let item = viewModel.items.first,
            player.currentItem == nil else { return }
        
        print("DEBUG: Initial play.")
        let playerItem = item.playerItem
        player.replaceCurrentItem(with: playerItem)
    }
    
    func updatePlayer(id: String?) {
        guard let currentPost = viewModel.items.first(where: { $0.id == id }) else {
            return
        }
        
        player.replaceCurrentItem(with: nil)
        let playerItem = currentPost.playerItem
        player.replaceCurrentItem(with: playerItem)
    }
}

#Preview {
    Paging()
}
