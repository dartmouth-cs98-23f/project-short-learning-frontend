//
//  TopicPageView.swift
//  Discite
//
//  Created by Bansharee Ireen on 1/26/24.
//

import SwiftUI

struct ToggleRoles: View {
    @State private var rolesVisible = false

    var body: some View {
        VStack(alignment: .leading) {
            if rolesVisible {
                Button(action: {
                    withAnimation {
                        self.rolesVisible.toggle()
                    }
                }) {
                    Text("Hide Roles")
                        .padding(.horizontal, 0)
                }
            } else {
                Button(action: {
                    withAnimation {
                        self.rolesVisible.toggle()
                    }
                }) {
                    Text("See Roles")
                }
            }
            
            if rolesVisible {
                Text("Place spider-graph here")
            }
        }
    }
}

struct TopicPageView: View {
    @ObservedObject var sequence: Sequence
    @Binding var tabSelection: Navigator.Tab
    @State private var columns: [GridItem] = [
        GridItem(.flexible()), GridItem(.flexible())
    ]
    
    var body: some View {
        let smallTextSize = CGFloat(16)
        let topBottom = CGFloat(32)
        let leadTrail = CGFloat(24)
        
        HStack(alignment: .center) {
            Button {
                tabSelection = .Explore
            } label: {
                Text("< Explore")
                    .font(.system(size: smallTextSize))
                    .foregroundColor(Color.primaryPurpleDark)
            }
            
            Spacer()
            Button {
                // bookmark/save this topic
            } label: {
                Text("Bookmark")
                    .font(.system(size: smallTextSize))
                    .foregroundColor(Color.primaryPurpleDark)
            }
        }
        .padding([.top], topBottom)
        .padding([.leading, .trailing], leadTrail)
        
        LazyVStack(alignment: .center, spacing: 10) {
            Text("Topic")
                .font(Font.H5)
                .foregroundColor(Color.primaryPurpleDark)
        
            Text("Basic Auth")
                .font(Font.H3)
        }
        .padding([.top, .bottom], topBottom)
        .padding([.leading, .trailing], leadTrail)
        
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 10) {
                // description
                Text("Description")
                    .font(Font.H5)
                
                Text("The Internet is a global network of computers connected to each other which communicate through a standardized set of protocols.")
                
                // "See roles" button
                ToggleRoles()
                
                // playlists
                VStack(alignment: .leading, spacing: 12) {
                    Text("Playlists").font(Font.H5)
                    
                    LazyVGrid(columns: columns, spacing: 1) {
                        ForEach(Array(sequence.playlists.enumerated()), id: \.offset) { index, playlist in
                            PlaylistCard(tabSelection: $tabSelection, playlist: playlist, index: index, width: 165, height: 200)
                        }
                    }
                }
            
            }
            .padding([.bottom], topBottom)
            .padding([.leading, .trailing], leadTrail)
        }
    }
}
