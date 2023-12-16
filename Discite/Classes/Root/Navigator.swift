//
//  Navigator.swift
//  Discite
//
//  Created by Jessie Li on 11/11/23.
//

import SwiftUI

struct Navigator: View {
    
    @State private var selection: Tab = .Watch
    @EnvironmentObject var context: MyContext
    
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
                if context.player.currentItem != nil {
                    PlayerView()
                } else {
                    Loading()
                         .frame(maxWidth: .infinity, maxHeight: .infinity)
                         .background(Color.primaryBlueBlack)
                }

            case .Explore:
                ExploreView(tabSelection: $selection)
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
        .onAppear {
            print("Navigator appeared.")
        }
    }
}

//#Preview {
//    
//    let context = MyContext()
//    var view: any View = Text("Loading...")
//    
//    Task {
//        do {
//            async let sequence = VideoService.loadSequence()
//            async let topics = ExploreService.loadTopics()
//            
//            context.sequence = try await sequence
//            context.topics = await topics
//            
//            view = Navigator()
//                .environmentObject(context)
//            
//        } catch {
//            view = Text("Error loading content.")
//        }
//    }
//    
//    return view
//}
