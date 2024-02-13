//
//  SearchDestinationView.swift
//  Discite
//
//  Created by Bansharee Ireen on 2/13/24.
//

import SwiftUI

struct SearchDestinationView: View {
    @StateObject var viewModel = SearchViewModel()
    
    var body: some View {
        // searchbar 
        SearchBar(placeholder: viewModel.searchText, viewModel: viewModel)
            .padding(.bottom, 10)
            .foregroundColor(.primaryBlueNavy)

        Spacer()
    }
}
