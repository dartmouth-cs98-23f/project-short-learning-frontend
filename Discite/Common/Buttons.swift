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

struct ShareButton: View {
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

struct SaveButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: "bookmark")
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

struct Buttons_Previews: PreviewProvider {
    static var previews: some View {
        AccentPlayButton(action: { }, label: "PLAY")
            .previewDisplayName("Accent Play")
        
        ShareButton(action: { })
            .previewDisplayName("Share")
        
        SaveButton(action: { })
            .previewDisplayName("Save")
    }
}
