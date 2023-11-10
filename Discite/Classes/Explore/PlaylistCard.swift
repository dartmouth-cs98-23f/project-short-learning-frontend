//
//  PlaylistCard.swift
//  Discite
//
//  Created by Jessie Li on 11/9/23.
//

import SwiftUI

struct PlaylistCard: View {
    
    @EnvironmentObject var sequence: Sequence
    var playlist: Playlist
    
    var body: some View {
        NavigationLink {
            // Navigate to Watch on click, placeholder for now
            WatchView(showSidebar: .constant(false))
            
        } label: {
            Button {
                // Update sequence on click
                
            } label: {
                VStack(alignment: .leading) {
                    HStack {
                        Text(playlist.getData().title)
                            .font(Font.H5)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        SaveButton(action: { })
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("\(playlist.length()) videos")
                            .font(Font.small)
                        
                        HStack {
                            let fractionComplete = Double((playlist.getCurrentIndex() + 1)/playlist.length())
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 1)
                                    .fill(Color.primaryDarkNavy)
                                    .frame(width: 250 * fractionComplete, height: 4)
                                RoundedRectangle(cornerRadius: 1)
                                    .fill(Color.lightGray)
                                    .frame(width: 250, height: 4)
                            }
                            
                        }
                        
                    }
                }.padding(24)
            }
            .cardButtonFrame(width: 300, height: 150)
        }
    }
}

#Preview {
    // PlaylistCard()
    var previewPlaylist: Playlist?
    
    VideoService.fetchPlaylist(completion: { playlistData in
        
        do {
            previewPlaylist = try Playlist(data: playlistData)
        } catch {
            print("\(error)")
        }
        
    }, failure: { error in
        print("\(error)")
    })
    
    if previewPlaylist != nil {
        return PlaylistCard(playlist: previewPlaylist!)
    } else {
        return Text("Failed to fetch playlist.")
    }
    
}
