//
//  AccountView.swift
//  Discite
//
//  Created by Jessie Li on 10/22/23.
//
//  Source:
//      https://medium.com/geekculture/side-menu-in-ios-swiftui-9fe1b69fc487

import SwiftUI

struct AccountView: View {
    
    @ObservedObject var viewModel: AccountViewModel = AccountViewModel()

    var body: some View {
        VStack {
            Spacer()
            Text("Account View")
            Spacer()
        }
        .padding(.horizontal, 24)
        .onAppear {
            print("Account appear")
        }
        .onDisappear {
            print("Account disappear")
        }
        
        PrimaryActionButton(action: {
            viewModel.logout()
            print("Logged out.")
        }, label: "Home.LogoutButton.Title", disabled: false)
        
    }
    
}
