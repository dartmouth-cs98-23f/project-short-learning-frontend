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

#Preview {
    let samplePlaylists = VideoService.fetchTestSequence()!.playlists
    let sampleFriend = Friend(id: "1", username: "janedoe", firstName: "Jane", lastName: "Doe", profileImage: "person.circle")
    
    let sharedPlaylist1 = SharedPlaylist(id: "1", playlist: samplePlaylists[0], sender: sampleFriend, hasWatched: true)
    
    let sharedPlaylist2 = SharedPlaylist(id: "2", playlist: samplePlaylists[1], sender: sampleFriend, hasWatched: false)
    
    return VStack(spacing: 24) {
        SharedCard(sharedPlaylist: sharedPlaylist1).padding([.leading, .trailing], 24)
        SharedCard(sharedPlaylist: sharedPlaylist2).padding([.leading, .trailing], 24)
    }
    
}
