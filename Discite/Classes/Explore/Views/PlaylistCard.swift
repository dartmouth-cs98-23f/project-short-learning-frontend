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
    var cardHeight: CGFloat = 250
    
    @Binding var isWatchShowing: Bool
    
    @Environment(TabSelectionManager.self) private var tabSelection
    
    var body: some View {
        Button {
            print("Setting playlist seed to \(playlist.playlistId).")
            tabSelection.setSeed(playlist: playlist)
            isWatchShowing = true
                
        } label: {
            ZStack(alignment: .bottom) {
                
                // image
                if let imageURL = playlist.thumbnailURL {
                    AsyncImage(url: URL(string: imageURL)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: imageWidth, height: cardHeight)
                            .clipped()
                        
                    } placeholder: {
                        ProgressView()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(width: imageWidth, height: cardHeight)
                    
                } else {
                    Rectangle()
                        .fill(Color.grayNeutral)
                        .frame(width: imageWidth, height: cardHeight)
                }
                
                // details
                VStack(alignment: .leading, spacing: 8) {
                    Text(playlist.title)
                        .font(.subtitle2)
                        .foregroundStyle(Color.primaryBlueBlack)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .clipped()
                    
                    Text(playlist.description ?? "")
                        .font(.body2)
                        .foregroundStyle(Color.grayDark)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    
                }
                .padding(32)
                .frame(maxWidth: imageWidth, alignment: .leading)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .shadow(color: Color.gray.opacity(0.4), radius: 10, x: 2, y: 2)
                        .padding(16)
                }
                
            }
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .shadow(color: Color.grayDark.opacity(0.5), radius: 10, x: 2, y: 2)
            }
            
        }
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
    
    return ExplorePlaylistPreviewCard(
        playlist: playlistPreview,
        isWatchShowing: .constant(false))
        .environment(TabSelectionManager(selection: .Explore))
}
