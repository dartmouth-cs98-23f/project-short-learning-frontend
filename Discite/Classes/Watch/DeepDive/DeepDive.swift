//
//  DeepDive.swift
//  Discite
//
//  Created by Jessie Li on 11/3/23.
//

import SwiftUI

struct DeepDive: View {
    
    @EnvironmentObject var sequence: Sequence
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // Playlist details
            playlistDetails(playlist: sequence.playlists[sequence.currentIndex])
            
            HStack {
                Spacer()
                
                // Continue button should close DeepDive
                ContinueButton {
                    isPresented = false
                }
            }
            .padding([.bottom, .top], 20)
            
            // Display a row for each video in the playlist
            ForEach(sequence.playlists[sequence.currentIndex].allVideos(), id: \.index) { video in
                videoRow(title: video.data.title,
                         description: video.data.description,
                         currentIndex: sequence.playlists[sequence.currentIndex].currentIndex,
                         videoIndex: video.index)
            }

        }
        .padding(32)
    }
    
    func playlistDetails(playlist: Playlist) -> some View {
        VStack(alignment: .leading) {
            Text(playlist.data.tags.joined(separator: ", ")).font(Font.body1)
            Text(playlist.data.title).font(Font.H3)
            
            HStack {
                // Placeholder profile image
                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading) {
                    Text("Tom Smith").font(Font.H6)
                    Text("@tomsmith").font(Font.small)
                }
            }
            .padding(.bottom, 15)
            
            Text(playlist.data.description).font(Font.body1)
        }
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
                sequence.playlists[sequence.currentIndex].currentIndex = videoIndex
                isPresented = false
                
            } label: {
                if currentIndex == videoIndex {
                    Image(systemName: "play.filled")
                } else if currentIndex > videoIndex {
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
    DeepDive(isPresented: .constant(true))
        .environmentObject(Sequence())
}
