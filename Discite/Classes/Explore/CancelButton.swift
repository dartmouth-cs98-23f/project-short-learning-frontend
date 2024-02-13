//
//  CancelButton.swift
//  Discite
//
//  Created by Bansharee Ireen on 2/12/24.
//

import SwiftUI

struct CancelButton: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: SearchViewModel
    @State var cancelButtonOffset: CGFloat
    
    var body: some View {
        Button("Cancel") {
            endEditing()
        }
        .padding(.leading, 0)
        .padding(.trailing, 18)
        .offset(x: cancelButtonOffset)
        .onAppear {
            // cancel button slides in from right
            withAnimation(.easeOut(duration: 0.5)) {
                cancelButtonOffset = 0
            }
        }
    }
    
    private func endEditing() {
        viewModel.searchText = ""
        viewModel.isFocused = false
        presentationMode.wrappedValue.dismiss()
    }
}
