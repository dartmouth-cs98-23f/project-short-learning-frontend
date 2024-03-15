//
//  OnboardingTopics.swift
//  Discite
//
//  Created by Jessie Li on 2/27/24.
//

import SwiftUI

struct OnboardingTopics: View {
    @ObservedObject var viewModel: OnboardViewModel
    @State private var totalHeight = CGFloat.zero
    let horizontalSpacing: CGFloat = 8
    let verticalSpacing: CGFloat = 8

    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical) {
                VStack {
                    VStack(spacing: 4) {
                        Text("Pick topics.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.H2)

                        Text("Select topics that interest you.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.body1)
                    }
                    .padding(.horizontal, 18)
                    .foregroundStyle(Color.primaryBlueBlack)

                    Spacer(minLength: 52)

                    topicCloud(in: geo)

                }
                .padding(.vertical, 24)
            }
        }
    }

    @ViewBuilder
    private func topicButton(_ index: Int) -> some View {
        Button {
            viewModel.topics[index].selected.toggle()

        } label: {
            Text(viewModel.topics[index].title)
                .font(.body1)
                .foregroundStyle(viewModel.topics[index].selected ? Color.white : Color.primaryBlueBlack)
                .padding(12)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(viewModel.topics[index].selected ? Color.primaryBlueBlack : Color.white)
                        .strokeBorder(Color.primaryBlueBlack, lineWidth: 2)
                }
        }
    }

    // stackoverflow.com/questions/62102647
    @ViewBuilder
    private func topicCloud(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        ZStack(alignment: .topLeading) {
             ForEach(viewModel.topics.indices, id: \.self) { i in
                topicButton(i)
                    .padding(.horizontal, horizontalSpacing)
                    .padding(.vertical, verticalSpacing)
                    .alignmentGuide(.leading, computeValue: { dimension in
                        if abs(width - dimension.width) > geometry.size.width {
                            width = 0
                            height -= dimension.height
                        }
                        let result = width
                        if viewModel.topics[i] == viewModel.topics.last! {
                            width = 0 // last item
                        } else {
                            width -= dimension.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { _ in
                        let result = height
                        if viewModel.topics[i] == viewModel.topics.last! {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }
        .background(viewHeightReader($totalHeight))

    }

    @ViewBuilder
    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }

}

#Preview {
    OnboardingTopics(viewModel: OnboardViewModel())
}
