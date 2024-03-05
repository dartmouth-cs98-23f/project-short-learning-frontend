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
            HStack {
                TextField(placeholder ?? "Search", text: $viewModel.searchText, onEditingChanged: { editing in
                    self.viewModel.isFocused = editing
                }, onCommit: {
                    // hitting enter: search action
                    self.viewModel.performSearch()
                    self.viewModel.searchHistory.append(self.viewModel.searchText)
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

                        if !self.viewModel.searchText.isEmpty {
                            Button {
                                self.viewModel.searchText = ""
                            } label: {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.grayDark)
                            }
                        }
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

                if viewModel.isFocused {
                    CancelButton(viewModel: viewModel, cancelButtonOffset: 100)
                }
            }

            if viewModel.isFocused && viewModel.searchText.isEmpty { // focus + no text
                // search history section
                viewModel.showSearchHistory()
            } else if !viewModel.searchText.isEmpty { // focus + text
                // search suggestions section
                viewModel.showSuggestions()
            }
        }
    }
}
