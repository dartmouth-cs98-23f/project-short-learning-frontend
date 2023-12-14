//
//  Navigator.swift
//  Discite
//
//  Created by Jessie Li on 11/11/23.
//

import SwiftUI

struct Navigator: View {
    
    @State private var selection: Tab = .Watch
    @StateObject var sequence: Sequence = Sequence()
    @StateObject var recommendations: Recommendations = Recommendations()
    
    let tabs = [TabItem(systemImage: "play.square.fill", tag: .Watch),
                TabItem(systemImage: "magnifyingglass", tag: .Explore),
                TabItem(systemImage: "person.2.fill", tag: .Shared),
                TabItem(systemImage: "person.crop.circle", tag: .Account)]
    
    enum Tab {
        case Watch
        case Explore
        case Shared
        case Account
    }
    
    struct TabItem {
        let systemImage: String
        let tag: Tab
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            switch selection {
            case .Watch:
                PlayerView()
                    .environmentObject(sequence)
                    .environmentObject(recommendations)
            case .Explore:
                ExploreView(tabSelection: $selection)
                    .environmentObject(sequence)
                    .environmentObject(recommendations)
            case .Shared:
                Shared()
            case .Account:
                AccountView()
            }
            
            HStack {
                ForEach(tabs, id: \.tag) { tab in
                    Button {
                        selection = tab.tag
                    } label: {
                        Image(systemName: tab.systemImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: 24)
                            .foregroundColor(selection == .Watch ? .secondaryPeachLight : .primaryBlueBlack)
                    }
                }
            }
            .padding(.top, 18)
            .background(selection == .Watch ? .black : .white)
        }
        .task {
            print("Preloading...")
            async let playlists = sequence.load(topicId: nil, numPlaylists: 3)
            async let topics = recommendations.load()
            
            sequence.playlists = await playlists
            recommendations.topics = await topics
        }
    }
}

#Preview {
    return Navigator()
}
