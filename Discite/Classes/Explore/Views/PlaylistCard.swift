//
//  PlaylistCard.swift
//  Discite
//
//  Created by Jessie Li on 11/9/23.
//

import SwiftUI

struct PlaylistPreviewCard: View {
    var playlist: PlaylistPreview
    
    @Environment(TabSelectionManager.self) private var tabSelection
    
    var body: some View {
        Button {
            tabSelection.playlistSeed = playlist
            tabSelection.selection = .Watch
                
        } label: {
            ZStack {
                if let imageURL = playlist.thumbnailURL {
                    AsyncImage(url: URL(string: imageURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(1, contentMode: .fill)

                    } placeholder: {
                        Rectangle()
                            .fill(Color.grayNeutral)
                            .frame(maxHeight: .infinity)
                    }
                    
                } else {
                    Rectangle()
                        .fill(Color.grayNeutral)
                        .frame(maxHeight: .infinity)
                }
      
                Color.black.opacity(0.6)
                
                VStack(spacing: 15) {
                    HStack(alignment: .bottom) {
                        Text(playlist.title)
                            .font(Font.H6)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                }
                .padding([.horizontal, .bottom], 10)
                .foregroundColor(.secondaryPeachLight)
            }
            .aspectRatio(1, contentMode: .fill)
            
        }
    }
}

#Preview {
    ExploreView()
        .environment(TabSelectionManager(selection: .Explore))
}
