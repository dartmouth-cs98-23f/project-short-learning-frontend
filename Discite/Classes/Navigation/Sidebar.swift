//
//  Sidebar.swift
//  Discite
//
//  Created by Jessie Li on 10/23/23.
//
//  Source:
//      https://medium.com/geekculture/side-menu-in-ios-swiftui-9fe1b69fc487

import SwiftUI

struct Sidebar: View {
    
    @Binding var selectedSidebarItem: Int
    @Binding var showSidebar: Bool
    let sidebarWidth: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
        
            ForEach(SidebarItem.allCases, id: \.self) { row in
                sidebarRow(isSelected: selectedSidebarItem == row.rawValue, title: row.title) {
                    selectedSidebarItem = row.rawValue
                    showSidebar.toggle()
                }
            }
                    
            Spacer()
        }
        .padding(.top, 100)
        .background(Color.white)
        .frame(width: sidebarWidth)
    }
    
    func sidebarRow(isSelected: Bool,
                    title: String,
                    hideDivider: Bool = false,
                    action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            
            HStack(spacing: 20) {
                Rectangle()
                    .fill(isSelected ? .blue : .white)
                    .frame(width: 5)
                    
                Text(title)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(isSelected ? .blue : .black)
                    
                Spacer()
            }
        }
        .frame(height: 50)
    }
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        Sidebar(selectedSidebarItem: .constant(0), showSidebar: .constant(false), sidebarWidth: 150)
    }
}
