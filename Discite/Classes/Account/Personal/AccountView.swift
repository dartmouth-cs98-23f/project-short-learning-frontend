//
//  AccountView.swift
//  Discite
//
//  Created by Jessie Li on 10/22/23.
//  Modified by Jessie Li on 2/9/24.
//

import SwiftUI

struct AccountView: View {
    @Environment(TabSelectionManager.self) private var tabSelection
    @EnvironmentObject private var user: User
    
    @State var statistics: [Statistic]?
    @State var topics: [TopicTag] = []
    @State var spiderGraphData: SpiderGraphData?
    @ObservedObject var viewModel: AccountViewModel = AccountViewModel()
    @ObservedObject var friendsViewModel = FriendsViewModel()
    @State var friends: [Friend]?
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView(.vertical) {
                    VStack(spacing: 32) {
                        basicInformation()
                        
                        // friends button
                        friendsButton()
                        
                        progressSummary()
                        
                        recentTopics()
                        
                        spiderGraph()
                            .frame(minHeight: 350)
                        
                        exploreFooter()
                    }
                    .padding([.leading, .trailing], 18)
                    .padding(.bottom, 64)
                    .task {
                        if viewModel.error != nil {
                            return
                        }
                        
                        if self.statistics == nil {
                            self.statistics = await viewModel.getProgressSummary()
                        }
                        
                        if self.topics.isEmpty {
                            self.topics = await viewModel.getRecentTopics() ?? []
                        }
                        
                        if self.spiderGraphData == nil {
                            self.spiderGraphData = await viewModel.getSpiderGraphData()
                        }
                        
                        friends = await friendsViewModel.getFriends()
                    }
                }
                .frame(maxWidth: .infinity)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        menuButton()
                    }
                }
                
                NavigationBar()
            }

        }
        
    }
    
    func menuButton() -> some View {
        NavigationLink {
            AccountMenu(viewModel: viewModel)
        } label: {
            Image(systemName: "line.horizontal.3")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
        }
        .foregroundColor(.primaryBlueBlack)
    }
    
    func basicInformation() -> some View {
        VStack {
            Image(systemName: "person.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
            
            Text(user.fullName)
                .font(.H3)

            Text(user.username)
                .font(.body1)
        }
    }
    
    func friendsButton() -> some View {
        NavigationLink {
            FriendsPage()
        } label: {
            VStack {
                if let count = friends?.count {
                    Text("\(count)")
                        .font(.H5)
                    Text("Friends")
                        .font(.body1)
                } else {
                    Text("0")
                        .font(.H5)
                    Text("Friends")
                        .font(.body1)
                }
            }
            .padding(0)
        }
        .foregroundColor(.primaryBlueBlack)
    }
    
    func progressSummary() -> some View {
        VStack(alignment: .leading) {
            Text("Summary")
                .font(.H5)
            
            HStack(spacing: 8) {
                if let statistics {
                    ForEach(statistics) { stat in
                        summaryCard(statistic: stat)
                    }
                
                } else {
                    placeholderRectangle(minHeight: 100)
                }
    
            }
        }
        .animation(.easeIn(duration: 0.3), value: statistics == nil)
    }
    
    func summaryCard(statistic: Statistic) -> some View {
        VStack {
            Text(statistic.value)
                .font(.H3)
            
            Text(statistic.item)
                .font(.body2)
            
            Text(statistic.timeframe.uppercased())
                .font(.button)
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .foregroundColor(.primaryPurpleLight)
        .background(Color.primaryPurpleLightest)

    }
    
    func recentTopics() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Recent topics")
                    .font(.H5)
                Spacer()
                allTopicsButton()
            }
            
            if !topics.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach($topics) { $topic in
                            TopicTagWithNavigation(topic: $topic)
                        }
                    }
                }
                .frame(minHeight: 40)
                
            } else {
                placeholderRectangle(minHeight: 40)
            }

        }
        .animation(.easeIn(duration: 0.5), value: topics.isEmpty)
    }
    
    func allTopicsButton() -> some View {
        NavigationLink {
            Placeholder()
        } label: {
            Text("See all of my topics (17)")
                .font(.small)
                .foregroundColor(.primaryPurple)
        }
    }
    
    func spiderGraph() -> some View {
        VStack(alignment: .leading) {
            Text("My roles")
                .font(.H5)
            
            if let spiderGraphData = spiderGraphData {
                GeometryReader { geometry in
                    let center = CGPoint(x: geometry.size.width/2, y: geometry.size.height/2)
                    
                    SpiderGraph(
                        axes: spiderGraphData.axes,
                        values: spiderGraphData.data,
                        textColor: spiderGraphData.titleColor,
                        center: center,
                        radius: 125
                    )
                }
            } else {
                placeholderRectangle(minHeight: 400)
            }
        }
        .animation(.easeIn(duration: 0.3), value: spiderGraphData == nil)
    }
    
    func exploreFooter() -> some View {
        VStack(alignment: .leading) {
            Text("Looking for something else?")
                .font(.H5)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Button {
                    tabSelection.selection = .Explore
                } label: {
                    primaryActionButton(label: "Explore")
                }
                
                NavigationLink {
                    SavedPage()
                } label: {
                    secondaryActionButton(label: "View saved")
                }

            }
        }
    }
    
    func placeholderRectangle(minHeight: CGFloat) -> some View {
        Rectangle()
            .frame(maxWidth: .infinity, minHeight: minHeight)
            .foregroundColor(.grayLight)
    }
    
}

#Preview {
    AccountView()
        .environment(TabSelectionManager(selection: .Account))
        .environmentObject(User())
}
