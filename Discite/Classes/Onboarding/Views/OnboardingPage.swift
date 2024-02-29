//
//  OnboardingPage.swift
//  Discite
//
//  Created by Jessie Li on 2/27/24.
//

import SwiftUI

struct OnboardingPage: View {
    @EnvironmentObject var user: User
    
    let totalPages = 3
    @State var currentPage = 0
    @StateObject var viewModel = OnboardViewModel()
    
    let transition: AnyTransition = .asymmetric(
        insertion: .move(edge: .trailing),
        removal: .move(edge: .leading))
    
    var body: some View {
        VStack(alignment: .leading) {
            progressDots()
                .padding(.horizontal, 18)
            
            switch currentPage {
            case 0:
                OnboardingComplexity(viewModel: viewModel)
                    .transition(transition)
            case 1:
                OnboardingSpider(viewModel: viewModel)
                    .transition(transition)
            case 2:
                OnboardingTopics(viewModel: viewModel)
                    .transition(transition)
            default:
                Hello()
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                // back
                if currentPage > 0 {
                    Button {
                        withAnimation {
                            currentPage -= 1
                        }
                        
                    } label: {
                        HStack(alignment: .center) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                    .font(.button)
                    .foregroundStyle(Color.primaryPurple)
                }
                
                Spacer()
                
                // next
                if currentPage < totalPages - 1 {
                    Button {
                        withAnimation {
                            currentPage += 1
                        }
                        
                    } label: {
                        HStack(alignment: .center) {
                            Text("Next")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            
                            Image(systemName: "chevron.right")
                        }
                    }
                    .font(.button)
                    .foregroundStyle(Color.primaryPurple)
                    
                } else {
                    Button {
                        Task {
                            await viewModel.mockOnboard(user: user)
                        }
                        
                    } label: {
                        Text("FINISH")
                    }
                }
            }
        }
        .padding(.top, 36)
    }
    
    @ViewBuilder 
    func progressDots() -> some View {
        HStack {
            ForEach(0..<totalPages, id: \.self) { i in
                Circle()
                    .frame(width: i == currentPage ? 12 : 8)
                    .foregroundStyle(i == currentPage ?
                                     Color.secondaryPurplePink : Color.grayNeutral)
                
            }
        }
    }
}

#Preview {
    OnboardingPage()
        .environmentObject(User())
}
