//
//  SinglePlaylistWatchCover.swift
//  Discite
//
//  Created by Jessie Li on 3/9/24.
//

import SwiftUI

struct SinglePlaylistWatchCover: View {
    @Environment(\.dismiss) var dismiss
    let playlistId: String

    var body: some View {
        WatchSinglePlaylist(playlistId: playlistId)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()

                } label: {
                    HStack(alignment: .center, spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(.button)
                    .foregroundStyle(Color.secondaryPeachLight)
                }
                .foregroundStyle(Color.secondaryPeachLight)
            }
        }
    }
}

#Preview {
    SinglePlaylistWatchCover(playlistId: "65d8fc3495f306b28d1b88d6")
        .environment(TabSelectionManager.init(selection: .Explore))
        .environmentObject(User())
}
