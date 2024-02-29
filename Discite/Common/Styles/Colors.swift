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
    static let primaryBlue = Color("Blue")
    static let primaryBlueBlack = Color("BlueBlack")
    static let primaryBlueNavy = Color("BlueNavy")
    static let primaryBlueLightest = Color("BlueLightest")
    
    static let primaryPurpleDark = Color("PurpleDark")
    static let primaryPurple = Color("Purple")
    static let primaryPurpleLight = Color("PurpleLight")
    static let primaryPurpleLightest = Color("PurpleLightest")
    
    static let secondaryPurplePink = Color("PurplePink")
    static let secondaryPurplePinkLight = Color("PurplePinkLight")
    static let secondaryPurplePinkDark = Color("PurplePinkDark")
    static let secondaryPeach = Color("Peach")
    static let secondaryPeachLight = Color("PeachLight")
    static let secondaryPink = Color("Pink")
    static let secondaryOrange = Color("Orange")
    static let secondaryAqua = Color("Aqua")
    
    static let grayBlue = Color("BlueGray")
    static let grayNeutral = Color("Gray")
    static let grayLight = Color("GrayLightest")
    static let grayDark = Color("GrayDark")
    
    static let error = Color("Error")
}

extension LinearGradient {
    static let pinkOrangeGradient = LinearGradient(colors: [Color.secondaryPink, Color.secondaryOrange],
                                                   startPoint: .leading,
                                                   endPoint: .trailing)
    
    static let purpleLinear = LinearGradient(colors: [Color.primaryPurple, Color.primaryPurpleLight],
                                             startPoint: .leading,
                                             endPoint: .trailing)
    
    static let blueBlackLinear = LinearGradient(colors: [Color("BlueLinearDark"), Color("BlueLinearLight")],
                                           startPoint: .leading,
                                           endPoint: .trailing)
}

extension View {
    public func addGradient(gradient: LinearGradient?) -> some View {
        self.overlay(gradient).mask(self)
    }
}

struct ColorComponents {
    var red: Double
    var green: Double
    var blue: Double
    var opacity: Double

    init(_ color: Color) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        UIColor(color).getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        self.red = Double(red)
        self.green = Double(green)
        self.blue = Double(blue)
        self.opacity = Double(alpha)
    }
}

extension Color {
    // Custom function to interpolate between two colors given a value (0 to 1)
    static func interpolate(from start: Color, to end: Color, value: Double) -> Color {
        let frac = max(0, min(1, value))

        let s = ColorComponents(start)
        let e = ColorComponents(end)
        
        let red = s.red + (e.red - s.red) * frac
        let green = s.green + (e.green - s.green) * frac
        let blue = s.blue + (e.blue - s.blue) * frac
        let alpha = s.opacity + (e.opacity - s.opacity) * frac

        return Color(red: red, green: green, blue: blue, opacity: alpha)
    }
}
