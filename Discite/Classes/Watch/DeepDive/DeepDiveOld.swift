//
//  DeepDive.swift
//  Discite
//
//  Created by Jessie Li on 11/3/23.
//

import SwiftUI

struct DeepDiveOld: View {
    
    var playlist: Playlist
    
    @Binding var isPresented: Bool
    @State var isShowingShare: Bool = false
    
    var friends: [Friend] = Share.createSampleFriends()
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                
                // Playlist details
                playlistDetails(playlist: playlist)
                
                HStack(alignment: .top) {
                    uploaderProfile()
                    
                    Spacer()
                    
                    // Continue button should close DeepDive
                    AccentPlayButton(action: {
                        isPresented = false
                    }, label: playlist.getCurrentIndex() >= 0 ? "CONTINUE" : "PLAY")
                }
                .padding([.bottom, .top], 12)
                    
                ForEach(Array(playlist.allVideos().enumerated()), id: \.offset) { index, video in
                    videoRow(title: video.title,
                             description: video.description,
                             currentIndex: playlist.getCurrentIndex(),
                             videoIndex: index)
                }

            }
            .padding(32)
            .sheet(isPresented: $isShowingShare, content: {
                Share(playlist: SharedPlaylist(id: playlist.id, playlist: playlist, hasWatched: true), friends: friends, isShowing: $isShowingShare)
            })
        }
            
    }
    
    func playlistDetails(playlist: Playlist) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 18) {
                Spacer()
                ShareButton(action: { isShowingShare = true })
                SaveButton(action: { }, isSaved: false)
            }
            
            Text(playlist.title).font(Font.H3).padding(.top, 18)
            Text(playlist.description).font(Font.body1)
        }
    }
    
    func uploaderProfile() -> some View {
        HStack {
            // Placeholder profile image
            Image(systemName: "person.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading) {
                Text("Tom Smith").font(Font.H6)
                Text("@tomsmith11").font(Font.small)
            }
        }
        .padding(.top, 12)
    }
    
    // Returns a row for each video in the playlist
    func videoRow(title: String,
                  description: String,
                  currentIndex: Int,
                  videoIndex: Int) -> some View {
        
        HStack {
            VStack(alignment: .leading, content: {
                Text(title).font(Font.H6)
                Text(description).font(Font.body2)
            })
            
            Spacer()
            
            // Clicking on "play" should update queue position and close DeepDive
            Button {
                _ = playlist.setCurrentIndex(index: videoIndex)
                isPresented = false
                
            } label: {
                if currentIndex == videoIndex {
                    Image(systemName: "play.fill")
                } else if currentIndex < videoIndex {
                    Image(systemName: "play")
                } else {
                    Image(systemName: "arrow.counterclockwise")
                }
    
            }

        }
        .padding([.top, .bottom], 12)
    }
    
}

#Preview {
    let playlist = VideoService.fetchTestPlaylist(topicId: nil)
    
    if playlist != nil {
        return DeepDive(playlist: playlist!, isPresented: .constant(true))
    } else {
        return Text("No DeepDive preview available.")
    }
}
