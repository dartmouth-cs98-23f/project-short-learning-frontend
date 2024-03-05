//
//  MainExplorePageSearchWrapper.swift
//  Discite
//
//  Created by Jessie Li on 3/4/24.
//

import SwiftUI

struct MainExplorePageSearchWrapper: View {
    @State var searchText: String = ""
    @StateObject var searchViewModel = ExploreSearchViewModel.shared
    
    var body: some View {
        NavigationStack {
            MainExplorePage(searchText: $searchText)
                .navigationTitle("Explore")
        }
        .searchable(text: $searchText)
    }
}

#Preview {
    MainExplorePageSearchWrapper()
        .environment(TabSelectionManager(selection: .Explore))
        .environmentObject(User())
}
