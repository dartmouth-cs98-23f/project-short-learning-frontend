//
//  ContentView.swift
//  Discite
//
//  Created by Jessie Li on 10/14/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var auth = Auth.shared
    @StateObject var sequence = Sequence()
    @StateObject var recommendations = Recommendations()
    
    init() { }
    
    var body: some View {
        if auth.loggedIn {
            Navigator()
                .environmentObject(sequence)
                .environmentObject(recommendations)
            
        } else {
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
