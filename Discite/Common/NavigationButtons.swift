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
                .frame(maxWidth: .infinity, maxHeight: 48)
                .foregroundColor(.white)
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
                .frame(maxWidth: .infinity, maxHeight: 48)
                .foregroundColor(disabled ? .grayNeutral : .primaryBlueBlack)
        }
        .disabled(disabled)
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(disabled ? Color.grayNeutral : Color.primaryBlueBlack,
                        lineWidth: 3)
        )
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
        PrimaryNavigationButton(destination: { Welcome() }, label: "Primary")
        SecondaryNavigationButton(destination: { Welcome() }, label: "Secondary")
        TextualNavigationButton(destination: { Welcome() }, label: "Textual")
    }
}
