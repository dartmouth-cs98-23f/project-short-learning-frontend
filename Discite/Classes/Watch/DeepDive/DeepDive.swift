//
//  DeepDive.swift
//  Discite
//
//  Created by Jessie Li on 12/9/23.
//

import SwiftUI

struct DeepDive: View {
    
    var playlist: Playlist
    
    @Binding var isPresented: Bool
    @State var isShowingShare: Bool = false
    
    var friends: [Friend] = Share.createSampleFriends()
    
    var body: some View {
        
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Image
                    AsyncImage(url: URL(string: playlist.thumbnailURL)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                        
                    } placeholder: {
                        Rectangle()
                            .fill(Color.grayNeutral)
                            .frame(height: 250)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    // Playlist details
                    playlistDetails(playlist: playlist)
                    
                    // Video sequence
                    videoDetails(playlist: playlist)
                    
                    // Related videos
                    relatedVideos(playlist: playlist)
                    
                }
                .sheet(isPresented: $isShowingShare, content: {
                    Share(playlist: SharedPlaylist(id: playlist.id, playlist: playlist, hasWatched: true), friends: friends, isShowing: $isShowingShare)
                })
                .padding(.bottom, 84)
            }
            
            VStack {
                // Continue button should close DeepDive
                PrimaryActionButtonPurple(action: {
                    isPresented = false
                }, label: playlist.getCurrentIndex() > 0 ? "Continue" : "Play")
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 18)
        }
        .padding([.leading, .trailing], 18)
            
    }
    
    func playlistDetails(playlist: Playlist) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 18) {
                Text(playlist.title).font(Font.H3)
                Spacer()
                ShareButton(action: { isShowingShare = true })
                SaveButton(action: { }, isSaved: false)
            }
            
            Text("\(playlist.length()) videos • \(playlist.getCurrentIndex()/playlist.length())% complete").font(.body2)
            
            uploaderProfile()
            
            Divider()
                .background(Color.grayNeutral)
            
            Text("Description")
                .font(Font.H5)
            Text(playlist.description).font(Font.body2)
            
            Divider()
                .background(Color.grayNeutral)
        }
    }
    
    func uploaderProfile() -> some View {
        HStack {
            // Placeholder profile image
            Image(systemName: "person.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
            
            Text("@tomsmith11").font(Font.small)
        }
    }
    
    func videoDetails(playlist: Playlist) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Videos")
                .font(Font.H5)
            
            ForEach(Array(playlist.allVideos().enumerated()), id: \.offset) { index, video in
                videoRow(title: video.title,
                         description: video.description,
                         currentIndex: playlist.getCurrentIndex(),
                         videoIndex: index)
            }
            
            Divider()
                .background(Color.grayNeutral)
        }
    }
    
    func relatedVideos(playlist: Playlist) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Related")
                .font(Font.H5)
        }
    }
    
    // Returns a row for each video in the playlist
    func videoRow(title: String,
                  description: String,
                  currentIndex: Int,
                  videoIndex: Int) -> some View {
        
        HStack(alignment: .top, spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(Font.H6)
                Text(description).font(Font.body2)
            }
            
            Spacer()
            
            // Clicking on "play" should update queue position and close DeepDive
            Button {
                _ = playlist.setCurrentIndex(index: videoIndex)
                isPresented = false
                
            } label: {
                if currentIndex == videoIndex {
                    Image(systemName: "play.fill")
                        .resizable()
                        .scaledToFit()
                        .addGradient(gradient: LinearGradient.purpleLinear)
                } else if currentIndex < videoIndex {
                    Image(systemName: "play")
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(systemName: "arrow.counterclockwise")
                        .resizable()
                }
    
            }
            .frame(width: 18, height: 18)
            .foregroundColor(.primaryBlueBlack)
            .padding(.top, 4)
        }
    }
    
}

//#Preview {
//    let playlist = VideoService.mockFetchPlaylist(topicId: nil)
//    
//    if playlist != nil {
//        return DeepDive(playlist: playlist, isPresented: .constant(true))
//    } else {
//        return Text("No DeepDive preview available.")
//    }
//}
