//
//  Fonts.swift
//  Discite
//
//  Created by Jessie Li on 11/1/23.
//
//  Reference:
//      Importing custom fonts: https://betterprogramming.pub/swiftui-basics-importing-custom-fonts-b6396d17424d

import SwiftUI

extension Font {
    
    // Headings
    static let H1 = Font.custom("Mulish-Bold", size: 56)
    static let H2 = Font.custom("Mulish-Bold", size: 40)
    static let H3 = Font.custom("Mulish-Bold", size: 28)
    static let H4 = Font.custom("Mulish-SemiBold", size: 26)
    static let H5 = Font.custom("Mulish-Bold", size: 20)
    static let H6 = Font.custom("Mulish-SemiBold", size: 18)
    
    // Subtitles
    static let subtitle1 = Font.custom("Mulish-SemiBold", size: 20)
    static let subtitle2 = Font.custom("Mulish-SemiBold", size: 16)
    
    // Body
    static let body1 = Font.custom("Mulish-Regular", size: 16)
    static let body2 = Font.custom("Mulish-Regular", size: 14)
    
    // Special
    static let small = Font.custom("Mulish-SemiBold", size: 12)
    static let button = Font.custom("Mulish-Bold", size: 16)
    static let captionBold = Font.custom("Mulish-ExtraBold", size: 12)
    static let price = Font.custom("Mulish-ExtraBold", size: 48)
    static let extraBig = Font.custom("Mulish-Light", size: 64)

}

struct Fonts: View {
    var body: some View {
        VStack {
            VStack {
                Text("H1")
                    .font(Font.H1)
                Text("H2")
                    .font(Font.H2)
                Text("H3")
                    .font(Font.H3)
                Text("H4")
                    .font(Font.H4)
                Text("H5")
                    .font(Font.H5)
                Text("H6")
                    .font(Font.H6)
            }
            
            VStack {
                Text("Body 1")
                    .font(Font.body1)
                Text("Body 2")
                    .font(Font.body2)
            }
            
            VStack {
                Text("Button")
                    .font(Font.button)
                Text("Small")
                    .font(Font.small)
            }
            
            Text("CAPTION")
                .font(Font.captionBold)
            
        }
    }
}

struct Fonts_Previews: PreviewProvider {
    static var previews: some View {
        Fonts()
    }
}
