//
//  WatchView.swift
//  Discite
//
//  Created by Jessie Li on 10/18/23.
//
//  Source:
//      https://medium.com/mop-developers/build-your-first-swiftui-app-part-5-handling-authorization-95f49cdb0b29

import SwiftUI

// Determines whether to display video player, deepdive, or redirect user to login
struct WatchView: View {
    
    @ObservedObject var viewModel: WatchViewModel = WatchViewModel()

    var body: some View {
        VStack {
            Spacer()
            Text("Watch View")
            
            PrimaryActionButton(action: {
                viewModel.logout()
                print("Logged out.")
            }, label: "Home.LogoutButton.Title", disabled: false)
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .onAppear {
            print("Watch appear")
        }
        .onDisappear {
            print("Watch disappear")
        }
    }
}

struct WatchView_Previews: PreviewProvider {
    static var previews: some View {
        WatchView()
    }
}
