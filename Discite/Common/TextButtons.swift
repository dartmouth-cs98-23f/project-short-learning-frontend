//
//  TextButtons.swift
//  Discite
//
//  Created by Jessie Li on 11/1/23.
//

import SwiftUI

struct PrimaryActionButton: View {
    let action: () -> Void
    let label: String
    let disabled: Bool
    
    init(action: @escaping () -> Void, label: String, disabled: Bool = false) {
        self.action = action
        self.label = label
        self.disabled = disabled
    }

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(Font.H6)
                .frame(maxWidth: .infinity, maxHeight: 48)
                .foregroundColor(.white)
        }
        .background(disabled ? Color.grayNeutral : Color.primaryBlueNavy)
        .disabled(disabled)
        .cornerRadius(10)
    }
}

struct PrimaryActionButtonBlue: View {
    let action: () -> Void
    let label: String
    let disabled: Bool
    
    init(action: @escaping () -> Void, label: String, disabled: Bool = false) {
        self.action = action
        self.label = label
        self.disabled = disabled
    }

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(Font.H6)
                .frame(maxWidth: .infinity, maxHeight: 48)
                .foregroundColor(.white)
        }
        .background(Color.grayNeutral)
        .addGradient(gradient: !self.disabled ? LinearGradient.blueBlackLinear : nil)
        .disabled(disabled)
        .cornerRadius(10)
    }
}

struct PrimaryActionButtonPurple: View {
    let action: () -> Void
    let label: String
    let disabled: Bool
    
    init(action: @escaping () -> Void, label: String, disabled: Bool = false) {
        self.action = action
        self.label = label
        self.disabled = disabled
    }

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(Font.H6)
                .frame(maxWidth: .infinity, maxHeight: 48)
                .foregroundColor(.white)
        }
        .background(!self.disabled ? LinearGradient.purpleLinear : nil)
        .background(self.disabled ? Color.grayNeutral : nil)
        .disabled(disabled)
        .cornerRadius(10)
    }
}

struct TextualButton: View {
    let action: () -> Void
    let label: String

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(Font.button)
                .foregroundColor(Color.primaryBlue)
        }
    }
}

struct TextButtons_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryActionButtonPurple(action: { }, label: "Share", disabled: false)
            .previewDisplayName("Primary Action Button")
        
    }
}
