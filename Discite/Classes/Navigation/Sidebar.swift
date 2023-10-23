//
//  SidebarView.swift
//  Discite
//
//  Created by Jessie Li on 10/23/23.
//
//  Source: 

import SwiftUI

struct Sidebar: View {
    
    @Binding var selectedSidebarItem: Int
    @Binding var showSidebar: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
        
            ForEach(SidebarItem.allCases, id: \.self) { row in
                SidebarRow(isSelected: selectedSidebarItem == row.rawValue, title: row.title) {
                    selectedSidebarItem = row.rawValue
                    showSidebar.toggle()
                }
            }
                    
            Spacer()
        }
        .padding(.top, 100)
        .background(Color.white)
    }
    
    func SidebarRow(isSelected: Bool, title: String, hideDivider: Bool = false, action: @escaping (()->())) -> some View {
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
