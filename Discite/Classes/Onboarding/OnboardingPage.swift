//
//  OnboardingPage.swift
//  Discite
//
//  Created by Jessie Li on 2/27/24.
//

import SwiftUI

struct OnboardingPage: View {
    let totalPages = 3
    @State var currentPage = 0
    @StateObject var viewModel = OnboardViewModel()
    let authViewModel = AuthViewModel.shared
    
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
                OnboardingTopics(viewModel: viewModel)
                    .transition(transition)
            case 2:
                OnboardingSpider(viewModel: viewModel)
                    .transition(transition)
                
            default:
                Hello()
                    // .transition(transition)
            }
//            NavigationStack {
//                OnboardingComplexity(viewModel: viewModel)
//            }
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
//                    NavigationLink {
//                        OnboardingTopics(viewModel: viewModel)
//                        
//                    } label: {
//                        HStack(alignment: .center) {
//                            Text("Next")
//                                .frame(maxWidth: .infinity, alignment: .trailing)
//                            
//                            Image(systemName: "chevron.right")
//                        }
//                    }
//                    .font(.button)
//                    .foregroundStyle(Color.primaryPurple)
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
                        authViewModel.onboardingComplete()
                        
                        Task {
                            await viewModel.mockOnboard()
                        }
                        
                    } label: {
                        Text("FINISH")
                    }
                }
            }
        }
        .padding(.top, 36)
    }
    
        // @ViewBuilder
//    func navigationButtons() -> ToolbarItemGroup<some View> {
//        ToolbarItemGroup(placement: .bottomBar) {
//            // back
//            Button {
//                // dismiss()
//                print("hello")
//                
//            } label: {
//                HStack(alignment: .center) {
//                    Image(systemName: "chevron.left")
//                    Text("Back")
//                }
//            }
//            .font(.button)
//            .foregroundStyle(Color.primaryPurple)
//            
//            Spacer()
//            
//            // next
//            NavigationLink {
//                OnboardingTopics()
//                
//            } label: {
//                HStack(alignment: .center) {
//                    Text("Next")
//                        .frame(maxWidth: .infinity, alignment: .trailing)
//                    
//                    Image(systemName: "chevron.right")
//                }
//            }
//            .font(.button)
//            .foregroundStyle(Color.primaryPurple)
//        }
//    }
    
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

//struct OnboardingData: Codable {
//    var complexity: Double
//    var topics: [String]
//    var roles: [
//}

#Preview {
    OnboardingPage()
}
