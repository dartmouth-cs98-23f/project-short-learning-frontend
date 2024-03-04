//
//  PlaylistCard.swift
//  Discite
//
//  Created by Jessie Li on 11/9/23.
//

import SwiftUI

struct ExplorePlaylistPreviewCard: View {
    var playlist: PlaylistPreview
    var imageWidth: CGFloat = 200
    var imageHeight: CGFloat = 130
    var cardHeight: CGFloat = 250
    
    @Environment(TabSelectionManager.self) private var tabSelection
    
    var body: some View {
        Button {
            tabSelection.setSeed(playlist: playlist)
            tabSelection.selection = .Watch
                
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                
                // image
                if let imageURL = playlist.thumbnailURL {
                    AsyncImage(url: URL(string: imageURL)) { image in
                        image
                            .resizable()

                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: imageWidth, height: imageHeight)
                    
                } else {
                    Rectangle()
                        .fill(Color.grayNeutral)
                        .frame(width: imageWidth, height: imageHeight)
                }
                
                // details
                VStack(alignment: .leading, spacing: 8) {
                    Text(playlist.title)
                        .font(.subtitle2)
                        .foregroundStyle(Color.primaryBlueBlack)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .clipped()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(playlist.description)
                        .font(.body2)
                        .foregroundStyle(Color.grayDark)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                    
                }
                .padding([.horizontal, .bottom], 10)
                
            }
        }
        .frame(width: imageWidth, height: cardHeight, alignment: .topLeading)
        .background {
            Rectangle()
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.5), radius: 4, x: 2, y: 2)
        }
        .padding(.all, 8)
    }
}

struct PlaylistPreviewCard: View {
    var playlist: PlaylistPreview
    
    @Environment(TabSelectionManager.self) private var tabSelection
    
    var body: some View {
        Button {
            tabSelection.setSeed(playlist: playlist)
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
    let playlistPreview = PlaylistPreview()
    
    return ExplorePlaylistPreviewCard(playlist: playlistPreview)
        .environment(TabSelectionManager(selection: .Explore))
}
