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
                    NestedAdapterWatchWrapper(
                        size: size, 
                        safeArea: safeArea
                    )
//                    WatchPage(
//                        size: size,
//                        safeArea: safeArea,
//                        seed: tabSelectionManager.playlistSeed)
//                        .ignoresSafeArea(.container, edges: .all)
                    
                case .Explore:
                    MainExplorePageSearchWrapper()
                    
                case .Saved:
                    SavedPage()
                case .Account:
                    AccountView()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .environment(tabSelectionManager)
    }
}

struct NavigationBar: View {
    @Environment(TabSelectionManager.self) private var tabSelection
    var foregroundColor: Color = .primaryBlueBlack
    var backgroundColor: Color = .white
    
    let tabs = [TabItem(systemImage: "play.square.fill", tag: .Watch),
                TabItem(systemImage: "magnifyingglass", tag: .Explore),
                TabItem(systemImage: "bookmark.fill", tag: .Saved),
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
                        .foregroundColor(foregroundColor)
                }
            }
        }
        .padding(.top, 18)
        .frame(width: .infinity)
        .background(backgroundColor)
    }
}

enum Tab {
    case Watch
    case Explore
    case Saved
    case Account
}

struct TabItem {
    let systemImage: String
    let tag: Tab
}

@Observable class TabSelectionManager {
    var selection: Tab
    var topicSeed: TopicTag?
    private(set) var playlistSeed: PlaylistPreview?
    
    init(selection: Tab = Tab.Watch) {
        self.selection = selection
    }
    
    @MainActor
    public func setSeed(playlist: PlaylistPreview?) {
        playlistSeed = playlist
    }
}

#Preview {
    ContentView()
}
