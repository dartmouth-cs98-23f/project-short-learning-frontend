//
//  ShareConfirmation.swift
//  Discite
//
//  Created by Jessie Li on 11/13/23.
//

import SwiftUI

struct ShareConfirmation: View {

    @Environment(\.dismiss) var dismiss
    @Binding var isShowingShare: Bool
    @State var appeared: Bool = false
    var playlist: Playlist

    var body: some View {

        VStack(alignment: .center, spacing: 42) {
            Image(systemName: "checkmark")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.primaryPurpleLight)
                .scaleEffect(appeared ? 1 : 0.5)
                .animation(Animation.smooth(duration: 2), value: appeared)
                .onAppear {
                    appeared.toggle()
                }

            VStack(spacing: 8) {
                Text("Thanks for sharing")
                    .font(Font.H4)

                Text("\"\(playlist.title)\"")
                    .font(Font.H3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primaryPurpleLight)
            }

            VStack(spacing: 12) {
                Button {
                    isShowingShare.toggle()
                } label: {
                    primaryActionButton(label: "Keep learning", maxWidth: .infinity)
                }

                Button {
                    dismiss()
                } label: {
                    secondaryActionButton(label: "Share with more friends", maxWidth: .infinity)
                }
            }

        }
        .navigationBarBackButtonHidden(true)
        .padding([.leading, .trailing], 18)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                TextualButton(action: {
                    isShowingShare.toggle()
                }, label: "Done")
            }
        }

    }
}
