//
//  Shared.swift
//  Discite
//
//  Created by Jessie Li on 11/12/23.
//

import SwiftUI

struct Shared: View {
    
    var sampleShared: [SharedPlaylist] = []
    
    init() {
        let samplePlaylists = VideoService.fetchTestSequence()!.allPlaylists()
        let sampleFriend = Friend(id: "1", username: "janedoe", firstName: "Jane", lastName: "Doe", profileImage: "person.circle")
        
        for samplePlaylist in samplePlaylists {
            sampleShared.append(SharedPlaylist(id: samplePlaylist.id, 
                                               playlist: samplePlaylist,
                                               sender: sampleFriend,
                                               hasWatched: false))
            
        }
        
        for samplePlaylist in samplePlaylists {
            sampleShared.append(SharedPlaylist(id: samplePlaylist.id + "a",
                                               playlist: samplePlaylist,
                                               sender: sampleFriend,
                                               hasWatched: true))
            
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 20) {
                
                Text("Shared.Title")
                    .font(Font.H2)
                    .padding(.top, 18)
                    .padding([.leading, .trailing], 12)
                
                ForEach(self.sampleShared) { sharedPlaylist in
                    SharedCard(sharedPlaylist: sharedPlaylist)
                }
            }
            .padding([.top, .bottom], 32)
            .padding([.leading, .trailing], 24)
        }
    }
    
}

#Preview {
    Shared()
}
