//
//  Buttons.swift
//  Discite
//
//  Created by Jessie Li on 11/1/23.
//

import SwiftUI

struct Buttons: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct AccentPlayButton: View {
    let action: () -> Void
    let label: String
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: "play.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .addGradient(gradient: LinearGradient.pinkOrangeGradient)
                
                Text(label)
                    .foregroundColor(Color.secondaryPink)
                    .font(Font.captionBold)
            }
        }
    }
}

struct ShareButtonLabeled: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: "paperplane")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .foregroundColor(.primaryBlue)
                
                Text("Share")
                    .foregroundColor(.primaryBlue)
                    .font(.button)
            }
        }
    }
}

struct SaveButtonLabeled: View {
    let action: () -> Void
    let isSaved: Bool
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .foregroundColor(.primaryBlue)
                
                Text("Save")
                    .foregroundColor(.primaryBlue)
                    .font(.button)
            }
        }
    }
}

struct SaveButton: View {
    let action: () -> Void
    let isSaved: Bool
    
    var body: some View {
        Button(action: action) {
            Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
                .foregroundColor(.primaryDarkNavy)
        }
    }
}

struct Buttons_Previews: PreviewProvider {
    static var previews: some View {
        AccentPlayButton(action: { }, label: "PLAY")
            .previewDisplayName("Accent Play")
        
        ShareButtonLabeled(action: { })
            .previewDisplayName("Share (labeled)")
        
        SaveButton(action: { }, isSaved: false)
            .previewDisplayName("Save")
        
        SaveButtonLabeled(action: { }, isSaved: false)
            .previewDisplayName("Save (labeled)")
    }
}

struct PreferenceButton: View {
    var topic: String
    @State var selected: Bool
    var frameWidth: CGFloat
    @ObservedObject var viewModel: OnboardingViewModel
    let constants = Constants()
    
    var body: some View {
        Button(action: {
            if selected {
                viewModel.topics.removeAll {$0 == topic}
                selected = false
            } else {
                viewModel.topics.append(topic)
                selected = true
            }
            print("Category clicked \(topic)" )
            print(viewModel.topics)
        }) {
            VStack {
                Spacer()
                constants.icons[topic]?
                    .font(.largeTitle)
                Spacer()
                Text(topic)
                    .font(.system(size: 15))
                Spacer()
            }
            .frame(width: frameWidth, height: 130)
            .foregroundColor(viewModel.topics.contains(topic) == true ? .white : Color.primaryDarkNavy)
            .cornerRadius(10)
            .font(.small)
            .accentColor(Color.blue)
            .disabled(viewModel.topics.count == 0)
        }
        .padding()
        .background(viewModel.topics.contains(topic) == true ? LinearGradient(colors: [Color.blue, Color.primaryDarkNavy], startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [.white], startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.primaryDarkNavy, lineWidth: 2)
        )
    }
}
