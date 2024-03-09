//
//  NestedAdapterWatchWrapper.swift
//  Discite
//
//  Created by Jessie Li on 3/8/24.
//

import SwiftUI

struct NestedAdapterWatchWrapper: View {
    var seed: String?
    
    @StateObject var viewModel: SequenceViewModel
    
    init(seed: String? = nil) {
        self.seed = seed
        
        self._viewModel = StateObject(wrappedValue: SequenceViewModel(seed: seed))
    }
    
    var body: some View {
        if case .error = viewModel.state {
            errorView()

        } else if viewModel.items.isEmpty {
            ProgressView()
                .tint(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.black)
                .animation(.easeOut, value: viewModel.items.isEmpty)
            
        } else {
            NestedAdapterRepresentable(viewModel: viewModel)
                .background(.black)
        }
    }
    
    @ViewBuilder
    private func errorView() -> some View {
        VStack {
            Text("Error loading content.")
                .foregroundStyle(Color.secondaryPink)
                .containerRelativeFrame([.horizontal, .vertical])
            
            Spacer()
            
            NavigationBar()
        }
        .background(Color.primaryBlueBlack)
    }
}

#Preview {
    NestedAdapterWatchWrapper()
        .environment(TabSelectionManager(selection: .Watch))
        .environmentObject(User())
}
