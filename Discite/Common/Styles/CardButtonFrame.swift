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
}

#Preview {
    CardButtonFrame()
}
