//
//  TopicPageView.swift
//  Discite
//
//  Created by Bansharee Ireen on 1/26/24.
//

import SwiftUI

struct TopicPageView: View {
    var topicSeed: TopicTag
    var topic: Topic
    
    @StateObject var viewModel = TopicViewModel()
    
    private var columns: [GridItem] = [
        GridItem(.flexible()), GridItem(.flexible())
    ]
    
    var body: some View {
        let topBottom = CGFloat(24)
        let leadTrail = CGFloat(24)
        
        LazyVStack(alignment: .center, spacing: 10) {
            HStack(alignment: .center) {
                Spacer()
                
                Text("Topic")
                    .font(Font.H5)
                    .foregroundColor(Color.primaryPurpleDark)
                
                Spacer()
                Button {
                    // bookmark/save this topic
                } label: {
                    Image(systemName: "bookmark.fill")
                        .foregroundColor(Color.primaryPurpleDark)
                }
            }
        
            Text(topic.topicName)
                .font(Font.H3)
        }
        .padding(.top, 0)
        .padding([.bottom], topBottom)
        .padding([.leading, .trailing], leadTrail)
        .navigationBarTitleDisplayMode(.inline)
        
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 10) {
                // description
                Text("Description")
                    .font(Font.H5)
                
                Text(topic.description ?? "")
                
                // "See roles" button
                ToggleRoles()
                
                // playlists
                VStack(alignment: .leading, spacing: 12) {
                    Text("Playlists").font(Font.H5)
                    
                }
            
            }
            .padding([.bottom], topBottom)
            .padding([.leading, .trailing], leadTrail)
        }
    }
}

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
