//
//  OnboardingPage.swift
//  Discite
//
//  Created by Jessie Li on 2/23/24.
//

import SwiftUI

struct OnboardingPage: View {
    @ObservedObject var viewModel = OnboardViewModel()
    @State var spiderGraphEntry = SpiderGraphEntry(
        values: [0.8, 0.8, 1.0, 0.7, 0.9, 0.75],
        color: .primaryPurpleLight,
        interactive: true)
    
    private let roles = ["Front", "Backend", "ML", "AI/Data", "DevOps", "QA"]
    
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
                    
                    ZStack {
                        SpiderGraph(
                            axes: roles,
                            values: [spiderGraphEntry],
                            textColor: .grayDark,
                            center: center,
                            radius: radius * 0.72
                        )
                    }
                }
                .frame(maxHeight: radius * 2.2)
                
                Text("Drag the corners of the graph to customize your interests.")
                    .font(.body1)
                    .lineSpacing(8.0)
                    .foregroundStyle(Color.primaryBlueBlack)
                
                // submit button
                Button {
                    Task {
                        await viewModel.mockSubmitPreferences(parameters: OnboardRolesRequest(roles: roles, values: spiderGraphEntry.values))
                    }
                    
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
                .foregroundStyle(Color.primaryBlue)
                .padding(12)
            }
            .frame(maxHeight: .infinity)
        }
        .padding(.horizontal, 18)
    }
    
    // Update values when a corner is dragged
    func onCornerDrag(values: [CGFloat]) {
        spiderGraphEntry.values = values
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
}
