//
//  SearchBar.swift
//  Discite
//
//  Created by Jessie Li on 12/13/23.
//

import SwiftUI

struct SearchBar: View {
    var placeholder: String?
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        VStack {
            TextField(placeholder ?? "Search", text: $viewModel.searchText, onEditingChanged: { editing in
                self.viewModel.isFocused = editing
            }, onCommit: {
                // hitting enter: search action
                self.viewModel.performSearch()
            })
            .font(Font.body)
            .padding(8)
            .padding(.horizontal, 24)
            .background(Color.primaryBlueLightest)
            .cornerRadius(10)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                }
                .padding([.leading, .trailing], 8)
            )
            .onTapGesture {
                self.viewModel.isFocused = true
            }
            .onReceive(viewModel.$isFocused) { isFocused in
                if !isFocused {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
        }
    }
}
