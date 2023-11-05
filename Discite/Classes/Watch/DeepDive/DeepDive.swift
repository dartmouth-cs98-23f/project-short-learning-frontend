//
//  DeepDive.swift
//  Discite
//
//  Created by Jessie Li on 11/3/23.
//

import SwiftUI

struct DeepDive: View {
    
    var playlist: Playlist?
    @Binding var isPresented: Bool
    
    var body: some View {
        if playlist != nil {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    
                    // Playlist details
                    playlistDetails(playlistData: playlist!.getData())
                    
                    HStack(alignment: .top) {
                        uploaderProfile()
                        
                        Spacer()
                        
                        // Continue button should close DeepDive
                        AccentPlayButton(action: {
                            isPresented = false
                        }, label: playlist!.getCurrentIndex() >= 0 ? "CONTINUE" : "PLAY")
                    }
                    .padding([.bottom, .top], 12)
                    
                    // Display a row for each video in the playlist
                    ForEach(playlist!.allVideos(), id: \.index) { video in
                        videoRow(title: video.data.title,
                                 description: video.data.description,
                                 currentIndex: playlist!.getCurrentIndex(),
                                 videoIndex: video.index)
                    }

                }
                .padding(32)
            }
            
        } else {
            Text("No playlist is playing.")
        }
    }
    
    func playlistDetails(playlistData: SequenceData.PlaylistData) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 18) {
                Spacer()
                ShareButton(action: {})
                SaveButton(action: {})
            }
                
            Text(playlistData.tags.joined(separator: ", ")).font(Font.body1)
            Text(playlistData.title).font(Font.H3)
            Text(playlistData.description).font(Font.body1)
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
                playlist!.setCurrentIndex(index: videoIndex)
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
    do {
        let playlistData = try TestVideoData.playlistData()
        let playlist = try Playlist(data: playlistData)
        return DeepDive(playlist: playlist, isPresented: .constant(true))
    } catch {
        return Text("No preview available.")
    }
}
