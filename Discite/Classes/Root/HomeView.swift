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
    
    @State var showSidebar = false
    @State var selectedSidebarItem = 0
    
    var body: some View {
        ZStack {
            
            TabView(selection: $selectedSidebarItem) {
                WatchView(showSidebar: $showSidebar)
                    .tag(0)
                TopicsView(showSidebar: $showSidebar)
                    .tag(1)
                SharedView(showSidebar: $showSidebar)
                    .tag(2)
                AccountView(showSidebar: $showSidebar)
                    .tag(3)
            }
            
            SidebarContainer(sidebarWidth: 200, showSidebar: $showSidebar) {
                Sidebar(selectedSidebarItem: $selectedSidebarItem, showSidebar: $showSidebar, sidebarWidth: 200)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
