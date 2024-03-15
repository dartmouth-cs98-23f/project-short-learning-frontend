//
//  NavigationButtons.swift
//  Discite
//
//  Created by Jessie Li on 1/13/24.
//

import SwiftUI

struct PrimaryNavigationButton<Content: View>: View {
    @ViewBuilder let destination: Content
    let label: String
    let disabled: Bool

    init(destination: @escaping () -> Content,
         label: String,
         disabled: Bool = false) {

        self.destination = destination()
        self.label = label
        self.disabled = disabled
    }

    var body: some View {
        NavigationLink(destination: destination) {
            Text(label)
                .font(Font.H6)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .padding([.top, .bottom], 12)
        }
        .background(disabled ? Color.grayNeutral : Color.primaryBlueBlack)
        .disabled(disabled)
        .cornerRadius(5)
    }
}

struct SecondaryNavigationButton<Content: View>: View {
    @ViewBuilder let destination: Content
    let label: String
    let disabled: Bool

    init(destination: @escaping () -> Content,
         label: String,
         disabled: Bool = false) {

        self.destination = destination()
        self.label = label
        self.disabled = disabled
    }

    var body: some View {
        NavigationLink(destination: destination) {
            Text(label)
                .font(Font.H6)
                .frame(maxWidth: .infinity)
                .foregroundColor(disabled ? .grayNeutral : .primaryBlueBlack)
                .padding([.top, .bottom], 12)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .strokeBorder(disabled ? Color.grayNeutral : Color.primaryBlueBlack,
                                lineWidth: 3)
                )
        }
        .disabled(disabled)
    }
}

struct TextualNavigationButton<Content: View>: View {
    @ViewBuilder let destination: Content
    let label: String
    let disabled: Bool

    init(destination: @escaping () -> Content,
         label: String,
         disabled: Bool = false) {

        self.destination = destination()
        self.label = label
        self.disabled = disabled
    }

    var body: some View {
        NavigationLink(destination: destination) {
            Text(label)
                .font(Font.button)
        }
        .disabled(disabled)
    }
}

#Preview {
    NavigationStack {
        PrimaryNavigationButton(destination: { Hello() }, label: "Primary")
        SecondaryNavigationButton(destination: { Hello() }, label: "Secondary")
        TextualNavigationButton(destination: { Hello() }, label: "Textual")
    }
    .padding([.leading, .trailing], 12)
}
