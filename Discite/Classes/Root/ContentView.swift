//
//  ContentView.swift
//  Discite
//
//  Created by Jessie Li on 10/14/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        NavigationView {
            MainView()
                .environmentObject(Auth.shared)
                .fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: false)
                
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
