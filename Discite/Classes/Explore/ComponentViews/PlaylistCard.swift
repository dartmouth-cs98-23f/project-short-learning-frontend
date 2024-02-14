//
//  PlaylistCard.swift
//  Discite
//
//  Created by Jessie Li on 11/9/23.
//

import SwiftUI

struct PlaylistCard: View {
    
    @EnvironmentObject var sequence: Sequence
    @Environment(TabSelectionManager.self) private var tabSelection
    
    var playlist: Playlist
    // var index: Int
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        Button {
                // TODO: Update sequence on click
            tabSelection.selection = .Watch
                
        } label: {
            ZStack {
                AsyncImage(url: URL(string: playlist.thumbnailURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()

                } placeholder: {
                    Rectangle()
                        .fill(Color.grayNeutral)
                        .frame(maxHeight: .infinity)
                }
      
                Color.black.opacity(0.6)
                
                VStack(spacing: 15) {
                    HStack(alignment: .bottom) {
                        Text(playlist.title)
                            .font(Font.H6)
                            .multilineTextAlignment(.leading)
                            .padding([.leading], 60)
                            .padding([.trailing], 60)
                            .padding([.bottom], 0)
                    }
                }
                .padding([.top, .bottom], 32)
                .padding([.leading, .trailing], 12)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .foregroundColor(.secondaryPeachLight)
            }
            .frame(width: width, height: height)
            .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
}

struct PlaylistPreviewCard: View {
    var playlist: PlaylistPreview
    
    @Environment(TabSelectionManager.self) private var tabSelection
    
    var body: some View {
        Button {
            // TODO: Update sequence on click
            // tabSelection.selection = .Watch
                
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
