//
//  IconButtons.swift
//  Discite
//
//  Created by Jessie Li on 11/13/23.
//

import SwiftUI

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

struct IconButtons_Previews: PreviewProvider {
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