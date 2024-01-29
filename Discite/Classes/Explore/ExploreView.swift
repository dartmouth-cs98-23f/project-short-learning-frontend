//
//  ExploreView.swift
//  Discite
//
//  Created by Jessie Li on 11/8/23.
//

import SwiftUI

struct ExploreView: View {
    @State private var columns: [GridItem] = [
            GridItem(.flexible()), GridItem(.flexible())
        ]
    
    @ObservedObject var sequence: Sequence
    @StateObject var recommendations = Recommendations()
    @Binding var tabSelection: Navigator.Tab
    @State var searchText: String = ""
    
    var body: some View {
        NavigationStack {
<<<<<<< HEAD
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Explore.Title")
                    .font(Font.H2)
                    .padding(.top, 18)
                    
                    SearchBar(placeholder: "Search for topics and playlists",
                              text: $searchText)
                    .foregroundColor(.primaryBlueNavy)
        
                    // Section: Recommended topics
                    topicScrollSection(heading: "Recommended topics", topics: recommendations.topics)
=======
            VStack(alignment: .leading, spacing: 24) {
                Text("Explore.Title")
                .font(Font.H2)
                .padding(.top, 18)
                
                SearchBar(placeholder: "Search for topics and playlists",
                          text: $searchText)
                .foregroundColor(.primaryBlueNavy)
            }
            .padding([.top, .leading, .trailing], 18)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Section: Recommended topics
                    topicScrollSection(heading: "Recommended topics", topics: recommendations.topics)
    
                    // Section: Recommended playlists
                    playlistScrollSection(heading: "Recommended playlists", playlists: sequence.playlists)
                }
                .padding(18)
            }
            .task {
                await recommendations.load()
            }
            .padding(18)
        }
        .task {
            await recommendations.load()
        }

    }
>>>>>>> 7f080ed (merge)
    
                    // Section: Recommended playlists
                    playlistScrollSection(heading: "Recommended playlists", playlists: sequence.playlists)
                }
                .padding(18)
            }
            .task {
                await recommendations.load()
                
            }
        }
    }

    struct TopicPageScreen: View {
        let value: String
        
        init(value: String) {
            self.value = value
            print("INIT SCREEN: \(value)")
        }
        
        var body: some View {
            Text("Screen \(value)")
        }
    }
 
    // Horizontally scrolling list of topics
    func topicScrollSection(heading: String, topics: [Topic]) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            
            HStack(alignment: .center) {
                Text(heading).font(Font.H5)
                
                Spacer()
                Button {
                    tabSelection = .Topics
                } label: {
                    Text("See all topics")
                        .font(.system(size: 12))
                        .foregroundColor(Color.primaryPurpleDark)
                }
            }
            
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(topics, id: \._id) { topic in
                        NavigationLink(destination: {
                            TopicPageView(sequence: sequence, tabSelection: $tabSelection, topic: topic)
                        }, label: {
                            TopicCard(tabSelection: $tabSelection, topic: topic, width: 100, height: 30)
                        })
                    }
                }
            }
            .padding([.top], 5)
        }
    }
    
    // Vertically scrolling 2 column grid of playlists
    func playlistScrollSection(heading: String, playlists: [Playlist]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(heading).font(Font.H5)
            
            LazyVGrid(columns: columns, spacing: 1) {
                ForEach(Array(playlists.enumerated()), id: \.offset) { index, playlist in
                    PlaylistCard(tabSelection: $tabSelection, playlist: playlist, index: index, width: 165, height: 200)
                }
            }
        }
    }
}
