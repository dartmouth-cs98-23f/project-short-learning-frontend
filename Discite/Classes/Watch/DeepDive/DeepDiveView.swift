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
            
            // Continue button should close DeepDive
            Button {
                isPresented = false
            } label: {
                VStack {
                    Image(systemName: "play.circle.fill")
                    Text("Continue")
                }
            }

            // Display a row for each video in the playlist
            ForEach(videoQueue.getAllVideos(), id: \.index) { video in
                videoRow(title: "Video title",
                         description: "Video description here.",
                         watched: video.index == videoQueue.getCurrentIndex(),
                         index: video.index)
            }

        }
        
    }
    
    func playListDetails(videoQueue: VideoQueue) -> some View {
        VStack {
            Text(videoQueue.getQueueTitle())
            Text(videoQueue.getQueueDescription())
            
            HStack {
                // Placeholder profile image
                Image(systemName: "person.circle")
                
                VStack {
                    Text(videoQueue.getQueueCreator().getFullName())
                    Text(videoQueue.getQueueCreator().getUserName())
                }
            }
        }
    }
    
    // Returns a row for each video in the playlist
    func videoRow(title: String,
                  description: String,
                  watched: Bool,
                  index: Int) -> some View {
        
        HStack {
            VStack {
                Text(title)
                Text(description)
            }
            
            Spacer()
            
            // Clicking on "play" should update queue position and close DeepDive
            Button {
                videoQueue.setCurrentIndex(currentIndex: index)
                isPresented = false
            } label: {
                watched ? Image(systemName: "play") : Image(systemName: "arrow.counterclockwise")
            }

        }
        
    }
    
}

struct DeepDiveView_Previews: PreviewProvider {
    static var previews: some View {
        DeepDiveView(isPresented: .constant(true))
            .environmentObject(VideoQueue())
    }
}
