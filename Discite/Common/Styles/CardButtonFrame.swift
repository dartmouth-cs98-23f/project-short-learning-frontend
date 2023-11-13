//
//  CardFrame.swift
//  Discite
//
//  Created by Jessie Li on 11/9/23.
//

import SwiftUI

struct CardButtonFrame: View {
    var body: some View {
        Button {
            // Update sequence on click
            
        } label: {
            Text("Button")
        }
        .cardButtonFrame(width: 200, height: 200)
        
        Button {
            // Update sequence on click
            
        } label: {
            Text("Button")
        }
        .cardButtonPressed(maxWidth: 200, maxHeight: 200)
    }
}

extension Button {
    
    public func cardButtonFrame(width: CGFloat, height: CGFloat) -> some View {
        self.frame(width: width, height: height)
            .background(Color.secondaryLightestBlue)
            .foregroundColor(Color.primaryBlueBlack)
            .cornerRadius(10)
            .shadow(color: Color.lightGray, radius: 2, x: 1, y: 4)
            .padding([.bottom, .top], 12)
    }
    
    public func cardButtonFrame(maxWidth: CGFloat, maxHeight: CGFloat) -> some View {
        self.frame(maxWidth: maxWidth, maxHeight: maxHeight)
            .background(Color.secondaryLightestBlue)
            .foregroundColor(Color.primaryBlueBlack)
            .cornerRadius(10)
            .shadow(color: Color.lightGray, radius: 2, x: 1, y: 4)
    }
    
    public func cardButtonPressed(maxWidth: CGFloat, maxHeight: CGFloat) -> some View {
        self.frame(maxWidth: maxWidth, maxHeight: maxHeight)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 3)
                    .blur(radius: 2)
                    .opacity(0.7)
                    .offset(x: -2, y: -4)
                    .clipped()
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.lightGray, lineWidth: 4)
                    .blur(radius: 1)
                    .offset(x: 1, y: 4)
                    .opacity(0.5)
                    .clipped()
            )
            .background(Color.lightestGray)
            .foregroundColor(Color.primaryBlueBlack)
            .cornerRadius(10)
        
    }
    
}

extension View {
    
    public func cardPressed(maxWidth: CGFloat, maxHeight: CGFloat) -> some View {
        self.frame(maxWidth: maxWidth, maxHeight: maxHeight)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 3)
                    .blur(radius: 2)
                    .opacity(0.7)
                    .offset(x: -2, y: -4)
                    .clipped()
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.lightGray, lineWidth: 4)
                    .blur(radius: 1)
                    .offset(x: 1, y: 4)
                    .opacity(0.5)
                    .clipped()
            )
            .background(Color.lightestGray)
            .foregroundColor(Color.primaryBlueBlack)
            .cornerRadius(10)
        
    }
}

#Preview {
    CardButtonFrame()
}
