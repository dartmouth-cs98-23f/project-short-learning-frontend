//
//  Shadows.swift
//  Discite
//
//  Created by Jessie Li on 12/8/23.
//

import SwiftUI

struct Shadows: View {
    var body: some View {
        Button {
            // Update sequence on click

        } label: {
            Text("Button with shadow")
        }
        .background(Color.primaryBlueLightest)
        .foregroundColor(Color.primaryBlueBlack)
        .cornerRadius(10)
        .cardOuterShadow()
    }
}

extension View {
    public func cardOuterShadow() -> some View {
        self.shadow(color: Color.grayNeutral, radius: 2, x: 1, y: 4)
            .padding([.bottom, .top], 12)
    }

    public func cardInnerShadow() -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white, lineWidth: 3)
                .blur(radius: 2)
                .opacity(0.7)
                .offset(x: -2, y: -4)
                .clipped()
        )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.grayNeutral, lineWidth: 4)
                    .blur(radius: 1)
                    .offset(x: 1, y: 4)
                    .opacity(0.5)
                    .clipped()
        )
    }
}

#Preview {
    Shadows()
}
