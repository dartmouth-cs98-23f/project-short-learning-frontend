//
//  DeepDive.swift
//  Discite
//
//  Created by Jessie Li on 10/31/23.
//

import SwiftUI

// Provides details for the current playlist
struct DeepDiveView: View {
    
    @Binding var isPresented: Bool
    @EnvironmentObject var videoQueue: VideoQueue

    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            // Playlist details
            playListDetails(videoQueue: videoQueue)
            
            HStack {
                Spacer()
                
                // Continue button should close DeepDive
                ContinueButton {
                    isPresented = false
                }
            }
            .padding([.bottom, .top], 20)
            
            // Display a row for each video in the playlist
            ForEach(videoQueue.getAllVideos(), id: \.index) { video in
                videoRow(title: "Video title",
                         description: "Video description here.",
                         watched: video.index == videoQueue.getCurrentIndex(),
                         index: video.index)
            }

        }
        .padding(32)
        
    }
    
    func playListDetails(videoQueue: VideoQueue) -> some View {
        VStack(alignment: .leading) {
            Text("Topic 1, Topic 2, Topic 3").font(Font.body1)
            Text(videoQueue.getQueueTitle()).font(Font.H3)
            
            HStack {
                // Placeholder profile image
                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading) {
                    Text(videoQueue.getQueueCreator().getFullName()).font(Font.H6)
                    Text("@" + videoQueue.getQueueCreator().getUserName()).font(Font.small)
                }
            }
            .padding(.bottom, 15)
            
            Text(videoQueue.getQueueDescription()).font(Font.body1)
        }
    }
    
    // Returns a row for each video in the playlist
    func videoRow(title: String,
                  description: String,
                  watched: Bool,
                  index: Int) -> some View {
        
        HStack {
            VStack(alignment: .leading, content: {
                Text(title).font(Font.H6)
                Text(description).font(Font.body2)
            })
            
            Spacer()
            
            // Clicking on "play" should update queue position and close DeepDive
            Button {
                videoQueue.setCurrentIndex(currentIndex: index)
                isPresented = false
            } label: {
                watched ? Image(systemName: "play") : Image(systemName: "arrow.counterclockwise")
            }

        }
        .padding([.top, .bottom], 12)
        
    }
    
}

struct DeepDiveView_Previews: PreviewProvider {
    static var previews: some View {
        DeepDiveView(isPresented: .constant(true))
            .environmentObject(VideoQueue())
    }
}
