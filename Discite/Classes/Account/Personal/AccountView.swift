//
//  AccountView.swift
//  Discite
//
//  Created by Jessie Li on 10/22/23.
//  Modified by Jessie Li on 2/9/24.
//

import SwiftUI

struct AccountView: View {
    @Binding var tabSelection: Navigator.Tab
    
    @State var user: User?
    @State var statistics: [Statistic]?
    @State var topics: [TopicTag]?
    @State var spiderGraphData: SpiderGraphData?

    @ObservedObject var viewModel: AccountViewModel = AccountViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(spacing: 32) {
                    basicInformation()
                        .task {
                            if user == nil {
                                user = await viewModel.getUser()
                            }
                        }
                    
                    progressSummary()
                        .task {
                            statistics = await viewModel.getProgressSummary()
                            
                        }
                    
                    recentTopics()
                        .task {
                            topics = await viewModel.getRecentTopics()
                        }
                    
                    spiderGraph()
                        .frame(minHeight: 350)
                        .task {
                            spiderGraphData = await viewModel.getSpiderGraphData()
                        }
                    
                    exploreFooter()
                }
                .padding([.leading, .trailing], 18)
            }
            .frame(maxWidth: .infinity)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    menuButton()
                }
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
            
            Text(user?.getFullName() ?? "")
                .font(.H3)
            
            Text(user?.username ?? "")
                .font(.body1)
        }
    }
    
    func progressSummary() -> some View {
        VStack(alignment: .leading) {
            Text("Summary")
                .font(.H5)
            
            HStack(spacing: 8) {
                if statistics != nil {
                    ForEach(statistics!) { stat in
                        summaryCard(statistic: stat)
                    }
                
                } else {
                    placeholderRectangle(minHeight: 100)
                }
    
            }
        }
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
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    if topics != nil {
                        ForEach(topics!) { topic in
                            TopicTagWithNavigation(topic: topic)
                        }

                    } else {
                        placeholderRectangle(minHeight: 30)
                    }
                }
            }

        }
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
                placeholderRectangle(minHeight: 350)
            }
        }
    }
    
    func exploreFooter() -> some View {
        VStack(alignment: .leading) {
            Text("Looking for something else?")
                .font(.H5)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Button {
                    tabSelection = .Explore
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
    AccountView(tabSelection: .constant(.Account), user: User.anonymousUser)
}
