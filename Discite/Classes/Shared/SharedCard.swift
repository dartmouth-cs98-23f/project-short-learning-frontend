//
//  SharedCard.swift
//  Discite
//
//  Created by Jessie Li on 11/12/23.
//

import SwiftUI

struct SharedCard: View {
    
    var sharedPlaylist: SharedPlaylist
    
    var body: some View {
        let button: Button = Button {
            // Open details view
                
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("\(sharedPlaylist.playlist.length()) videos").font(Font.small)
                        Text(sharedPlaylist.playlist.title).font(Font.H5)
                    }
                    
                    HStack {
                        Image(systemName: sharedPlaylist.sender!.profileImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        Text("@\(sharedPlaylist.sender!.username) · 2h ago").font(Font.body1)
                    }
                }
                
                Spacer()
                
                if !sharedPlaylist.hasWatched {
                    Image(systemName: "play.fill")
                    
                } else {
                    Image(systemName: "arrow.counterclockwise")
                }
            }
            .padding(18)
        }
        
        if sharedPlaylist.hasWatched {
            button
                .cardWithShadowPressed(maxWidth: .infinity, maxHeight: 150)
        } else {
            button
                .cardWithShadow(maxWidth: .infinity, maxHeight: 150)
        }
    
    }

}
