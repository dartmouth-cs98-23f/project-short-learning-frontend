//
//  ExplorePage.swift
//  Discite
//
//  Created by Jessie Li on 3/18/24.
//

import SwiftUI

struct ExplorePage: View {
    @ObservedObject private(set) var viewModel: ViewModel
    
    var body: some View {
        self.content
    }
    
    @ViewBuilder private var content: some View {
        switch viewModel.topicsAndRolesVideos {
        case .notRequested:
            notRequestedView
        case let .isLoading(last):
            loadingView(last)
        case let .loaded(countries):
            loadedView(countries, showSearch: true, showLoading: false)
        case let .failed(error):
            failedView(error)
        }
    }
}

// MARK: - Loading Content

private extension ExplorePage {
    var notRequestedView: some View {
        Text("").task {
            await viewModel.getExplorePage()
        }
    }
    
    func loadingView(_ previouslyLoaded: [any GenericTopic]?) -> some View {
        if let videos = previouslyLoaded {
            return AnyView(loadedView(videos, showSearch: true, showLoading: true))
            
        } else {
            return AnyView(ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity))
        }
    }
    
    func failedView(_ error: Error) -> some View {
        ErrorView2(error: error, retryAction: {
            await self.viewModel.getExplorePage()
        })
    }
}

// MARK: - Displaying Content

private extension ExplorePage {
    func loadedView(_ videos: [any GenericTopic], showSearch: Bool, showLoading: Bool) -> some View {
        VStack {
            if showSearch {
//                SearchBar(text: $viewModel.countriesSearch.searchText.onSet({ _ in
//                    self.viewModel.reloadCountries()
//                }))
            }
            
            if showLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
//            List(videos) { country in
//                NavigationLink(
//                    destination: self.detailsView(country: country),
//                    tag: country.alpha3Code,
//                    selection: self.$viewModel.routingState.countryDetails) {
//                        CountryCell(country: country)
//                    }
//            }
        }.padding(.bottom, bottomInset)
    }
    
    // THIS WOULD BE NAVIGATION VIEWS
    func detailsView(video: any GenericTopic) -> some View {
        Text(video.title)
//        CountryDetails(viewModel: .init(container: viewModel.container, country: country))
    }

    var bottomInset: CGFloat {
        if #available(iOS 14, *) {
            return 0
        } else {
            return self.viewModel.countriesSearch.keyboardHeight
        }
    }
}

// MARK: - Preview

#if DEBUG
#Preview {
    ExplorePage(viewModel: .init(container: .preview))
}
#endif
