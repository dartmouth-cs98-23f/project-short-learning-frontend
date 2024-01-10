//
//  OnboardingView.swift
//  Discite
//
//  Created by Colton Sankey on 11/8/23.
//

import Foundation
import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: OnboardingViewModel = OnboardingViewModel()
    @ObservedObject var auth = Auth.shared
    
    // @Binding var isShowing: Bool
    // @Binding var isSigningUp: Bool
    
    @State private var columns: [GridItem] = [
        GridItem(.flexible(minimum: 100, maximum: 200), spacing: 50)
    ]
    let constants = Constants()
    
    var body: some View {
        GeometryReader { geometry in
            let frameWidth: CGFloat = geometry.size.width>geometry.size.height ? (geometry.size.width/8-20) : (geometry.size.width/4-20)
            
            ZStack {
                ScrollView {
                    HStack {
                        Spacer()
                        Text("Select your interests")
                            .frame(alignment: .center)
                            .font(.title)
                        Spacer()
                    }
                    .padding()
                    if viewModel.internalError != "" {
                        Text(viewModel.internalError)
                            .foregroundStyle(.red)
                            .bold()
                    }
                    
                    LazyHGrid(rows: columns, spacing: 10) {
                        ForEach(constants.categories, id: \.self) {category in
                            VStack {
                                PreferenceButton(
                                    topic: category,
                                    selected: false,
                                    frameWidth: frameWidth,
                                    viewModel: viewModel
                                )
                            }
                        }
                    }
                    .onAppear {
                        updateGridColumns(width: geometry.size.width, height: geometry.size.height, frameWidth: frameWidth)
                    }
                }
                VStack {
                    Spacer()
                    Button(action: {Auth.shared.logout()}, label: { Text("logout")})
                    Button(action: {
                        viewModel.send()
                        
                        if viewModel.error == nil {
                            // isShowing = false
                            // isSigningUp = false
                        }
                        
                    }, label: {
                        Text("Submit")
                            .frame(width: geometry.size.width-32, height: 50)
                            .background(Color.primaryBlueNavy)
                            .foregroundColor(.white)
                            .padding()
                    })
                }
            }
            
        }
    }
    
    private func updateGridColumns(width: CGFloat, height: CGFloat, frameWidth: CGFloat) {
        let columnsCount = Int((CGFloat(constants.categories.count)+2) / 3)
        print(frameWidth, columnsCount)
        var gridColumns: [GridItem] = []
        
        for _ in 0..<columnsCount {
            gridColumns.append(GridItem(.flexible(minimum: frameWidth, maximum: frameWidth), spacing: 100))
        }
        columns = gridColumns
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        // OnboardingView(isShowing: .constant(false), isSigningUp: .constant(true))
        OnboardingView()
    }
}
