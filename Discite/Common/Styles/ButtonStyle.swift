//
//  ButtonStyle.swift
//  Discite
//
//  Created by Jessie Li on 10/18/23.
//
//  Source:
//      https://medium.com/mop-developers/build-your-first-swiftui-app-part-5-handling-authorization-95f49cdb0b29

import SwiftUI

struct PrimaryButton: ViewModifier {
    var color: Color = Color.blue
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: 500, maxHeight: 50)
            .foregroundColor(Color.white)
            .background(color)
    }
}
