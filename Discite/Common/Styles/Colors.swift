//
//  Colors.swift
//  Discite
//
//  Created by Jessie Li on 11/1/23.
//
//  Sources:
//      Adding gradient to a View: https://stackoverflow.com/questions/58991311/gradient-as-foreground-color-of-text-in-swiftui

import SwiftUI

extension Color {
    static let primaryBlueBlack = Color("BlueBlack")
    static let primaryDarkNavy = Color("DarkNavy")
    
    static let secondaryPink = Color("Pink")
    static let secondaryOrange = Color("Orange")
}

extension LinearGradient {
    static let pinkOrangeGradient = LinearGradient(colors: [Color.secondaryPink, Color.secondaryOrange],
                                                   startPoint: .leading,
                                                   endPoint: .trailing)
}

extension View {
    public func addGradient(gradient: LinearGradient) -> some View {
        self.overlay(gradient).mask(self)
    }
}
