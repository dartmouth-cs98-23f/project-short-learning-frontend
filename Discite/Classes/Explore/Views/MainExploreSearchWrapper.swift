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
    @State var didSubmitSearchQuery: Bool = false
    
    var body: some View {
        NavigationStack {
            MainExplorePage(searchText: $searchText)
                .navigationTitle("Explore")
                .navigationDestination(
                    isPresented: $didSubmitSearchQuery) {
                        SearchDestinationPage(text: searchText)
                    }
        }
        .searchable(text: $searchText)
        .onSubmit(of: .search) {
            didSubmitSearchQuery = true
        }
    }
}

#Preview {
    MainExplorePageSearchWrapper()
        .environment(TabSelectionManager(selection: .Explore))
        .environmentObject(User())
}
