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
        .cardWithShadow(width: 200, height: 200)
        
        Button {
            // Update sequence on click
            
        } label: {
            Text("Button")
        }
        .cardWithShadowPressed(maxWidth: 200, maxHeight: 200)
    }
}

extension View {
    
    public func cardFrame(width: CGFloat, height: CGFloat) -> some View {
        self.frame(width: width, height: height)
            .background(Color.primaryPurpleLightest)
            .foregroundColor(Color.primaryBlueBlack)
            .cornerRadius(10)
    }
    
    public func cardFramePressed(width: CGFloat, height: CGFloat) -> some View {
        self.frame(width: width, height: height)
            .addGradient(gradient: LinearGradient.blueBlackLinear)
            .foregroundColor(Color.primaryPurpleLight)
            .cornerRadius(10)
    }
    
    public func cardWithShadow(width: CGFloat, height: CGFloat) -> some View {
        self.frame(width: width, height: height)
            .background(Color.primaryBlueLightest)
            .foregroundColor(Color.primaryBlueBlack)
            .cornerRadius(10)
            .cardOuterShadow()
    }
    
    public func cardWithShadow(maxWidth: CGFloat, maxHeight: CGFloat) -> some View {
        self.frame(maxWidth: maxWidth, maxHeight: maxHeight)
            .background(Color.primaryBlueLightest)
            .foregroundColor(Color.primaryBlueBlack)
            .cornerRadius(10)
            .cardOuterShadow()
    }
    
    public func cardWithShadowPressed(maxWidth: CGFloat, maxHeight: CGFloat) -> some View {
        self.frame(maxWidth: maxWidth, maxHeight: maxHeight)
            .cardInnerShadow()
            .background(Color.grayLight)
            .foregroundColor(Color.primaryBlueBlack)
            .cornerRadius(10)
        
    }
    
    public func purpleTopicCard(width: CGFloat, height: CGFloat) -> some View {
        self.frame(width: width, height: height)
            .background(Color.primaryPurpleLightest)
            .foregroundColor(.black)
            .cornerRadius(5)
//            .overlay(
//                    RoundedRectangle(cornerRadius: 5)
//                    .stroke(Color.primaryPurpleLight, lineWidth: 3)
//            )
    }
}

#Preview {
    CardButtonFrame()
}
