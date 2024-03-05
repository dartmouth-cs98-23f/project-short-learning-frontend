//
//  IconButtons.swift
//  Discite
//
//  Created by Jessie Li on 11/13/23.
//

import SwiftUI

struct AccentPlayButton: View {
    let action: () -> Void
    let label: String?
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: "play.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .addGradient(gradient: LinearGradient.pinkOrangeGradient)
                
                if label != nil {
                    Text(label!)
                        .foregroundColor(Color.secondaryPink)
                        .font(Font.captionBold)
                }
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
                    .frame(width: 24, height: 24)
                    .foregroundColor(.primaryBlueNavy)
                
                Text("Share")
                    .foregroundColor(.primaryBlueNavy)
                    .font(.button)
            }
        }
    }
}

struct ShareButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "paperplane")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(.primaryBlueNavy)
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
                    .frame(width: 24, height: 24)
                    .foregroundColor(.primaryBlueNavy)
                
                Text("Save")
                    .foregroundColor(.primaryBlueNavy)
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
                .frame(width: 20, height: 20)
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
