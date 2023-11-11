//
//  HomeView.swift
//  Discite
//
//  Created by Jessie Li on 10/23/23.
//
//  Source:
//      https://medium.com/geekculture/side-menu-in-ios-swiftui-9fe1b69fc487

import SwiftUI

struct HomeView: View {

    @State private var selection: Tab = .Watch
    
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
                // WatchView()
                PlayerView()
            case .Explore:
                ExploreView()
            case .Shared:
                SharedView()
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
                            .frame(maxWidth: .infinity, maxHeight: 32)
                            .foregroundColor(selection == .Watch ? .secondaryLightPeach : .primaryBlueBlack)
                    }
                }
            }
            .padding(.top, 12)
            .background(selection == .Watch ? .black : .white)

        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let sequence = VideoService.fetchTestSequence()
        let recommendations = ExploreService.fetchTestRecommendations()
        
        if sequence != nil && recommendations != nil {
            HomeView()
                .environmentObject(sequence!)
                .environmentObject(recommendations!)
        } else {
            Text("Error fetching sequence or recommendations.")
        }
    }
}
