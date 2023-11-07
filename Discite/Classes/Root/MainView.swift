//
//  RootView.swift
//  Discite
//
//  Created by Jessie Li on 10/18/23.
//
//  Source:
//      https://medium.com/mop-developers/build-your-first-swiftui-app-part-5-handling-authorization-95f49cdb0b29
//      https://medium.com/geekculture/side-menu-in-ios-swiftui-9fe1b69fc487

import SwiftUI

struct MainView: View {
    @ObservedObject var auth = Auth.shared
      
    var body: some View {
        if auth.loggedIn {
            HomeView()
        } else {
            LoginView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
