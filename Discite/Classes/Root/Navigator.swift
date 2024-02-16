//
//  Navigator.swift
//  Discite
//
//  Created by Jessie Li on 11/11/23.
//

import SwiftUI

struct Navigator: View {
    @State private var tabSelectionManager = TabSelectionManager()
    @State var seedPlaylist: PlaylistPreview?
    
    var body: some View {
        
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            VStack(spacing: 0) {
                switch tabSelectionManager.selection {
                    
                case .Watch:
                    WatchPage(size: size, safeArea: safeArea)
                        .ignoresSafeArea(.container, edges: .all)
                    
                case .Explore:
                    ExploreView()
                case .Shared:
                    Shared()
                case .Account:
                    AccountView()
                }
            }
        }
        .environment(tabSelectionManager)
    }
}

struct NavigationBar: View {
    @Environment(TabSelectionManager.self) private var tabSelection
    
    let tabs = [TabItem(systemImage: "play.square.fill", tag: .Watch),
                TabItem(systemImage: "magnifyingglass", tag: .Explore),
                TabItem(systemImage: "person.2.fill", tag: .Shared),
                TabItem(systemImage: "person.crop.circle", tag: .Account)]
    
    var body: some View {
        HStack {
            ForEach(tabs, id: \.tag) { tab in
                Button {
                    tabSelection.selection = tab.tag
                } label: {
                    Image(systemName: tab.systemImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 24)
                        .foregroundColor(tabSelection.selection == .Watch ? .secondaryPeachLight : .primaryBlueBlack)
                }
            }
        }
        .padding(.top, 18)
        .background(tabSelection.selection == .Watch ? .clear : .white)
    }
}

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

@Observable class TabSelectionManager {
    var selection: Tab
    var topicSeed: TopicTag?
    var playlistSeed: PlaylistPreview?
    
    init(selection: Tab = Tab.Watch) {
        self.selection = selection
    }
}

#Preview {
    ContentView()
}
