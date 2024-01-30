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
                         // Post(playlist: item, scrollPosition: item.currentIndex, player: player)
                        Post2(playlist: item, player: player)
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
        }
    }
}

#Preview {
    Feed()
}
