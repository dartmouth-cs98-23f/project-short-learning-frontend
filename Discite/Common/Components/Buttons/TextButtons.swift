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
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .padding([.top, .bottom], 12)
        }
        .background(disabled ? Color.grayNeutral : Color.primaryBlueNavy)
        .disabled(disabled)
        .cornerRadius(5)
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
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .padding([.top, .bottom], 12)
        }
        .background(Color.grayNeutral)
        .addGradient(gradient: !self.disabled ? LinearGradient.blueBlackLinear : nil)
        .disabled(disabled)
        .cornerRadius(5)
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

func primaryActionButton(label: String, disabled: Bool = false) -> some View {
    Text(label)
        .font(Font.button)
        .foregroundColor(.white)
        .padding(12)
        .cornerRadius(5)
        .background {
            RoundedRectangle(cornerRadius: 5)
                .fill(disabled ? Color.grayNeutral : Color.primaryBlueNavy)
                .addGradient(gradient: !disabled ? LinearGradient.blueBlackLinear : nil)
        }
}

func primaryActionButton(label: String, disabled: Bool = false, maxWidth: CGFloat) -> some View {
    Text(label)
        .font(Font.button)
        .foregroundColor(.white)
        .padding(12)
        .cornerRadius(5)
        .frame(maxWidth: maxWidth)
        .background {
            RoundedRectangle(cornerRadius: 5)
                .fill(disabled ? Color.grayNeutral : Color.primaryBlueNavy)
                .addGradient(gradient: !disabled ? LinearGradient.blueBlackLinear : nil)
        }
}

func secondaryActionButton(label: String, disabled: Bool = false) -> some View {
    Text(label)
        .font(Font.button)
        .foregroundColor(disabled ? .grayNeutral : .primaryBlueBlack)
        .padding(12)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .strokeBorder(disabled ? Color.grayNeutral : Color.primaryBlueBlack, lineWidth: 2)
        )
}

func secondaryActionButton(label: String, disabled: Bool = false, maxWidth: CGFloat) -> some View {
    Text(label)
        .font(Font.button)
        .foregroundColor(disabled ? .grayNeutral : .primaryBlueBlack)
        .padding(12)
        .frame(maxWidth: maxWidth)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .strokeBorder(disabled ? Color.grayNeutral : Color.primaryBlueBlack, lineWidth: 2)
        )
}

#Preview {
    return secondaryActionButton(label: "Secondary")
}
