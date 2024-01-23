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
            AsyncImage(url: URL(string: playlist.thumbnailURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .overlay(
                        Text(playlist.title)
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding(8),
                        alignment: .bottom
                    )
                
            } placeholder: {
                Rectangle()
                    .fill(Color.grayNeutral)
                    .frame(maxHeight: .infinity)
            }
            .frame(width: width, height: height)
            .clipShape(RoundedRectangle(cornerRadius: 5))

//            ZStack {
//                AsyncImage(url: URL(string: playlist.thumbnailURL)) { image in
//                    image
//                        .resizable()
//                        .scaledToFill()
//                    
//                } placeholder: {
//                    Rectangle()
//                        .fill(Color.grayNeutral)
//                        .frame(maxHeight: .infinity)
//                }
//      
//                Color.black.opacity(0.6)
//                
//                VStack(spacing: 15) {
//                    HStack(alignment: .firstTextBaseline) {
//                        Text(playlist.title)
//                            .font(Font.H6)
//                            .multilineTextAlignment(.leading)
//                            .padding([.leading], 60)
//                            .padding([.trailing], 60)
//                            .padding([.bottom], 0)
//                        
////                        SaveButton(action: { }, isSaved: false)
////                            .padding(.top, 4)
//                        
//                    }
//                    
////                    Text("\(playlist.length()) videos")
////                        .font(Font.small)
//                }
//                .padding([.top, .bottom], 32)
//                .padding([.leading, .trailing], 12)
//                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
//                .foregroundColor(.secondaryPeachLight)
//            }
//            .frame(width: width, height: height)
//            .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
}
