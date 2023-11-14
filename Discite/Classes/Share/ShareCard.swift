//
//  ShareCard.swift
//  Discite
//
//  Created by Jessie Li on 11/13/23.
//

import SwiftUI

struct ShareCard: View {
    
    var playlist: Playlist
    
    var body: some View {
        
        Button {
                
        } label: {
            
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("\(playlist.length()) videos").font(Font.small)
                    Text(playlist.title).font(Font.H6)
                }
                
                Spacer()
                
                Image(systemName: "link")
            }
            .padding(24)
            
        }
        .cardPressed(maxWidth: .infinity, maxHeight: 84)

    }
}

#Preview {
    
    let samplePlaylists = VideoService.fetchTestSequence()!.playlists
    return ShareCard(playlist: samplePlaylists[0])
    
}