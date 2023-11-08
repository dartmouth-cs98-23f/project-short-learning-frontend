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
    @State var categories = ["Business", "Sports", "Cooking", "Finance", "Coding", "Math", "Boats", "Cars"]
    @State private var columns: [GridItem] = [
        GridItem(.flexible(minimum: 100, maximum: 200), spacing: 50)
    ]
    @State var icons = ["Business": Image(systemName: "briefcase"),
                        "Sports": Image(systemName: "football"),
                        "Cooking": Image(systemName: "frying.pan"),
                        "Finance": Image(systemName: "dollarsign"),
                        "Coding": Image(systemName: "desktopcomputer"),
                        "Math": Image(systemName: "plusminus")]
    
    var body: some View {
        GeometryReader { geometry in
            var frameWidth: CGFloat = geometry.size.width>geometry.size.height ? (geometry.size.width/8-20) : (geometry.size.width/4-20)
            ScrollView {
                LazyHGrid(rows: columns, spacing: 10) {
                    ForEach(categories, id: \.self) {category in
                        VStack {
                            Button(action: {
                                if viewModel.topics.contains(category) {
                                    viewModel.topics.removeAll {$0 == category}
                                } else {
                                    viewModel.topics.append(category)
                                }
                                print("Category clicked \(category)" )
                                print(viewModel.topics)
                            }) {
                                VStack {
                                    Spacer()
                                    icons[category]?
                                        .font(.largeTitle)
                                    Spacer()
                                    Text(category)
                                        .font(.system(size: 15))
                                    Spacer()
                                }
                                .frame(width: frameWidth, height: 130)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .font(.small)
                                .accentColor(Color.blue)
                                .disabled(viewModel.topics.count == 0)
                            }
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                        }
                        
                    }
                    
                }
                .padding()
                .onAppear {
                    updateGridColumns(geometry.size.width, geometry.size.height, frameWidth)
                }
                Button(action: {
                    viewModel.send()
                }, label: {
                    Text("Submit")
                        .frame(width: geometry.size.width-32, height: 50)
                        .background(Color.primaryDarkNavy)
                        .foregroundColor(.white)
                        .padding()
                })
            }
            
        }
    }
    
    private func updateGridColumns(_ width: CGFloat,_ height: CGFloat,_ frameWidth: CGFloat) {
        let availableWidth = width - 20 // Adjust this as needed
        
        let columnsCount = width<height ? Int((CGFloat(categories.count)+2) / 3) : Int((CGFloat(categories.count)+5) / 6)
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
        OnboardingView()
    }
}
