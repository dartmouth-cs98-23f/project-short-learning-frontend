//
//  RootView.swift
//  Discite
//
//  Created by Jessie Li on 10/18/23.
//
//  Source: https://medium.com/mop-developers/build-your-first-swiftui-app-part-5-handling-authorization-95f49cdb0b29

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var auth: Auth
    
    var body: some View {
        if auth.loggedIn {
            HomeView()
        } else {
            LoginView()
        }
    }
}

struct RootScreen_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(Auth.shared)
    }
}
