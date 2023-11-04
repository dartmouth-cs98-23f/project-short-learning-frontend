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
            playlistDetails(playlistData: sequence.currentPlaylist().getData())
            
            HStack {
                Spacer()
                
                // Continue button should close DeepDive
                ContinueButton {
                    isPresented = false
                }
            }
            .padding([.bottom, .top], 20)
            
            // Display a row for each video in the playlist
            ForEach(sequence.currentPlaylist().allVideos(), id: \.index) { video in
                videoRow(title: video.data.title,
                         description: video.data.description,
                         currentIndex: sequence.currentPlaylist().getCurrentIndex(),
                         videoIndex: video.index)
            }

        }
        .padding(32)
    }
    
    func playlistDetails(playlistData: SequenceData.PlaylistData) -> some View {
        VStack(alignment: .leading) {
            Text(playlistData.tags.joined(separator: ", ")).font(Font.body1)
            Text(playlistData.title).font(Font.H3)
            
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
            
            Text(playlistData.description).font(Font.body1)
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
                sequence.currentPlaylist().setCurrentIndex(index: videoIndex)
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
