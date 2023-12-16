//
//  PlaylistCard.swift
//  Discite
//
//  Created by Jessie Li on 11/9/23.
//

import SwiftUI

struct PlaylistCard: View {
    
    @EnvironmentObject var sequence: Sequence
    @Binding var tabSelection: Navigator.Tab
    
    var playlist: Playlist
    var index: Int
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        Button {
                // TODO: Update sequence on click
                tabSelection = .Watch
                
        } label: {
            ZStack {
                AsyncImage(url: URL(string: playlist.thumbnailURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                    
                } placeholder: {
                    Rectangle()
                        .fill(Color.grayNeutral)
                        .frame(maxHeight: .infinity)
                }
      
                Color.black.opacity(0.6)
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack(alignment: .top) {
                        Text(playlist.title)
                            .font(Font.H5)
                            .multilineTextAlignment(.leading)
                        
                        SaveButton(action: { }, isSaved: false)
                            .padding(.top, 4)
                    }
                    
                    Text("\(playlist.length()) videos")
                        .font(Font.small)
                }
                .padding([.top, .bottom], 32)
                .padding([.leading, .trailing], 12)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .foregroundColor(.secondaryPeachLight)
            }
            .frame(width: 230, height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

//#Preview {
//    do {
//        Task {
//            let playlist = try await VideoService.mockFetchPlaylist(topicId: nil)
//            return PlaylistCard(tabSelection: .constant(Navigator.Tab.Explore), playlist: playlist, index: 0, width: 200, height: 150)
//        }
//        
//    } catch {
//        return Text("Error fetching playlist.")
//    }
//    
//}
