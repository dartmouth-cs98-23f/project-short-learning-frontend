//
//  WatchPage.swift
//  Discite
//
//  Created by Jessie Li on 2/13/24.
//

import SwiftUI

struct WatchPage: View {
    var size: CGSize
    var safeArea: EdgeInsets
    var includeNavigation: Bool

    @Environment(TabSelectionManager.self) private var tabSelection
    @StateObject var viewModel: SequenceViewModel
    @State var likedCounter: [Like] = []

    init(size: CGSize, safeArea: EdgeInsets, seed: String? = nil, includeNavigation: Bool = true) {
        self.size = size
        self.safeArea = safeArea
        self.includeNavigation = includeNavigation

        self._viewModel = StateObject(
            wrappedValue: SequenceViewModel(seed: seed))
    }

    var body: some View {
        if case .error = viewModel.state {
            errorView()

        } else if viewModel.items.isEmpty {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tint(.white)
                .background(.black)
                .animation(.easeOut(duration: 0.1), value: viewModel.items.isEmpty)

        } else {
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.items) { item in
                        PlaylistView(viewModel: viewModel,
                                     playlist: item,
                                     likedCounter: $likedCounter,
                                     size: size,
                                     safeArea: safeArea,
                                     includeNavigation: includeNavigation)
                        .frame(maxWidth: .infinity)
                        .containerRelativeFrame(.vertical)
                        .onAppear {
                            viewModel.onItemAppear(playlist: item)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
            .background(.black)

            // like animation
            .overlay(alignment: .topLeading) {
                ZStack {
                    ForEach(likedCounter) { like in
                        Image(systemName: "hand.thumbsup.fill")
                            .font(.system(size: 72))
                            .addGradient(gradient: .pinkOrangeGradient)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .opacity(like.isAnimated ? 1 : 0)
                            .scaleEffect(like.isAnimated ? 0.5 : 1)
                            .animation(.smooth(duration: 1.5), value: like.isAnimated)
                    }
                }
            }
            .environment(\.colorScheme, .dark)
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
    // ContentView()
    GeometryReader { geo in
        WatchPage(size: geo.size, safeArea: geo.safeAreaInsets)
            .environment(TabSelectionManager(selection: .Watch))
            .environmentObject(User())
    }
}
