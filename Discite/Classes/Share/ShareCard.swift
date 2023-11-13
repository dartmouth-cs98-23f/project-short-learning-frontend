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
            }
            .padding(24)
            
        }
        .cardPressed(maxWidth: .infinity, maxHeight: 84)

    }
}

#Preview {
    
    let samplePlaylists = VideoService.fetchTestSequence()!.allPlaylists()
    let sampleFriend = Friend(id: "1", username: "janedoe", firstName: "Jane", lastName: "Doe", profileImage: "person.circle")
    
    let sharedPlaylist = SharedPlaylist(id: "1", playlist: samplePlaylists[0], sender: sampleFriend, hasWatched: false)
                                         
    return ShareCard(playlist: sharedPlaylist.playlist)
    
}
