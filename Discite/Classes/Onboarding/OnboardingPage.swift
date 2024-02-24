//
//  OnboardingPage.swift
//  Discite
//
//  Created by Jessie Li on 2/23/24.
//

import SwiftUI

struct OnboardingPage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var viewModel = OnboardViewModel()
    
    var body: some View {
        GeometryReader { mainGeo in
            let radius = mainGeo.size.width/2

            VStack(alignment: .leading) {
                // title
                Text("Create your ideal profile.")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color.primaryBlueBlack)
                    .font(.H2)
                
                // spider graph
                GeometryReader { geometry in
                    let center = CGPoint(x: radius, y: geometry.size.height/2)
                    
                    let spiderGraphEntry = SpiderGraphEntry(
                        values: viewModel.values,
                        color: .primaryPurpleLight,
                        interactive: true,
                        handleCornerDrag: onCornerDrag)
                    
                    SpiderGraph(
                        axes: viewModel.roles,
                        values: [spiderGraphEntry],
                        textColor: .grayDark,
                        center: center,
                        radius: radius * 0.72
                    )
                }
                .frame(maxHeight: radius * 2.2)
                
                // reset
                resetButton()
                
                // description
                Text("Drag the corners of the graph to customize your interests.")
                    .font(.body1)
                    .lineSpacing(8.0)
                    .foregroundStyle(Color.primaryBlueBlack)
                
                // submit button
                submitButton()
            }
            .frame(maxHeight: .infinity)
        }
        .padding(.horizontal, 18)
    }
    
    @ViewBuilder
    func resetButton() -> some View {
        Button {
            viewModel.resetGraphValues()

        } label: {
            HStack(alignment: .center) {
                Text("Reset")
                    .font(.button)
                Image(systemName: "arrow.counterclockwise")
            }
            .foregroundStyle(Color.primaryPurple)
        }
        .frame(alignment: .trailing)
        .padding(.vertical, 8)
    }
    
    @ViewBuilder
    func submitButton() -> some View {
        Button {
            Task {
                await viewModel.mockSubmitPreferences()
                // authViewModel.status = .loggedIn
            }
            
        } label: {
            NavigationLink {
                Navigator()
                
            } label: {
                HStack(alignment: .center) {
                    Spacer()
                    
                    Text("Start learning")
                        .font(.subtitle1)
                    
                    AnimatedArrow()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                }
            }
//            HStack(alignment: .center) {
//                Spacer()
//                
//                Text("Start learning")
//                    .font(.subtitle1)
//                
//                AnimatedArrow()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 20, height: 20)
//            }
        }
        .foregroundStyle(Color.primaryBlue)
        .padding(12)
    }
    
    // Update values when a corner is dragged
    func onCornerDrag(values: [CGFloat]) {
        viewModel.values = values
    }
}

private struct AnimatedArrow: View {
    @State private var arrowOpacity: Double = 1.0

    var body: some View {
        Image(systemName: "arrow.right")
            .resizable()
            .opacity(arrowOpacity)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5).repeatForever()) {
                    arrowOpacity = 0.4
                }
            }
    }
}

#Preview {
    OnboardingPage()
        .environmentObject(AuthViewModel())
}
