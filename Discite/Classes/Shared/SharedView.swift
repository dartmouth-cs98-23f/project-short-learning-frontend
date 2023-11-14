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

    var body: some View {
        VStack {
            Spacer()
            Text("Shared View")
            Spacer()
        }
        .padding(.horizontal, 24)
        .onAppear {
            print("Shared appear")
        }
        .onDisappear {
            print("Shared disappear")
        }
    }
    
}