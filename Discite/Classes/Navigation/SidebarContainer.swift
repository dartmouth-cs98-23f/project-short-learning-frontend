//
//  SidebarContainer.swift
//  Discite
//
//  Created by Jessie Li on 10/23/23.
//
//  Source:
//      https://betterprogramming.pub/create-a-sidebar-menu-180ca218eaf2
//      https://medium.com/geekculture/side-menu-in-ios-swiftui-9fe1b69fc487

import SwiftUI

struct SidebarContainer<SidebarContent: View>: View {
    
    let sidebarContent: SidebarContent
    let sidebarWidth: CGFloat
    @Binding var showSidebar: Bool
    
    init(sidebarWidth: CGFloat,
         showSidebar: Binding<Bool>,
         @ViewBuilder sidebar: () -> SidebarContent) {
        
        self.sidebarWidth = sidebarWidth
        self._showSidebar = showSidebar
        sidebarContent = sidebar()
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            
            if (showSidebar) {
                // Dim background
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showSidebar.toggle()
                    }
                
                // Show sidebar
                sidebarContent
                    .frame(width: sidebarWidth, alignment: .center)
                    .background(Color.clear)
                
            }
        }
        .animation(.easeInOut.speed(2), value: showSidebar)
        .edgesIgnoringSafeArea(.all)
    }
}

struct SidebarStack_Previews: PreviewProvider {
    
    static var previews: some View {
        ContainerView(sidebarWidth: 150, showSidebar: .constant(true)) {
            VStack {
                Text("Item 1")
                Text("Item 2")
                Text("Item 3")
            }
        } content: {
            Text("Main content")
        }.edgesIgnoringSafeArea(.all)
    }
}
