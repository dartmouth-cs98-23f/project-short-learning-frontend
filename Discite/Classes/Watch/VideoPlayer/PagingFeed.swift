//
//  Paging.swift
//  Discite
//
//  Created by Jessie Li on 1/21/24.
//
//  https://medium.com/whatnot-engineering/the-next-page-8950875d927a

import SwiftUI

struct Paging: View {
    @ObservedObject var viewModel = SequenceViewModel()
    
    var body: some View {
//        ScrollView {
//            LazyVStack {
//                ForEach(viewModel.items) { item in
//                    PlaylistView(playlist: item)
//                        .onAppear {
//                            viewModel.onItemAppear(playlist: item)
//                        }
//                }
//            }
//        }
        
        List {
            ForEach(viewModel.items) { item in
                PlaylistView(playlist: item)
                    .onAppear {
                        viewModel.onItemAppear(playlist: item)
                    }
            }
            .listRowInsets(EdgeInsets())
        }
        .listStyle(.plain)
    }
}

#Preview {
    Paging()
}
