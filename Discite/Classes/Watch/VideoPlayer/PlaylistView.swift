//
//  PlaylistView.swift
//  Discite
//
//  Created by Jessie Li on 1/21/24.
//

import SwiftUI
import AVKit

struct PlaylistView: View {
    @ObservedObject var playlist: Playlist
    
    var body: some View {
        
        if playlist.isLoading {
            ProgressView("Loading playlist...")
                .frame(width: .infinity, height: 250)
                .border(.pink)
            
        } else {
            ZStack(alignment: .top) {
                // Navigation dots
                dotNavigation(position: playlist.currentIndex, length: playlist.videos.count)
                
                Rectangle()
                    .frame(width: .infinity, height: 250)
                    .padding([.top, .bottom], 18)
            }
        }
    }
    
    func dotNavigation(position: Int, length: Int) -> some View {
        HStack(spacing: 4) {
            ForEach(0..<playlist.videos.count, id: \.self) { index in
                Circle()
                    .fill(Color.white.opacity(playlist.currentIndex == index ? 1 : 0.33))
                    .frame(width: 4, height: 4)
            }
        }
    }
}
