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

enum ContinueButtonSize: CaseIterable {
    case small, medium, large
}

struct ContinueButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: "play.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .addGradient(gradient: LinearGradient.pinkOrangeGradient)
                
                Text("CONTINUE")
                    .foregroundColor(Color.secondaryPink)
                    .font(Font.caption)
            }
        }
    }
}

struct Buttons_Previews: PreviewProvider {
    static var previews: some View {
        ContinueButton(action: { })
    }
}
