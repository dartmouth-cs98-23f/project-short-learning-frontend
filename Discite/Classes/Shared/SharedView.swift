//
//  SharedViewController.swift
//  Discite
//
//  Created by Jessie Li on 10/22/23.
//
//  Source:
//      https://medium.com/geekculture/side-menu-in-ios-swiftui-9fe1b69fc487

import SwiftUI

struct SharedView: View {
    
    @Binding var showSidebar: Bool

    var body: some View {
        VStack {
            HStack {
                Button {
                    showSidebar.toggle()
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundColor(Color.black)
                }
                
                Spacer()
            }
                    
            Spacer()
            Text("Shared View")
            Spacer()
        }
        .padding(.horizontal, 24)
    }
    
}
