//
//  YouTubeButton.swift
//  Discite
//
//  Created by Jessie Li on 3/7/24.
//

import SwiftUI

struct YouTubeButton: View {
    var video: Video?

    var body: some View {
        Button {
            openYouTube()
        } label: {
            HStack(spacing: 4) {
                Text("Open in YouTube")
                Image(systemName: "arrow.right")
            }
        }
        .font(.small)
        .foregroundStyle(Color.secondaryPurplePinkLight)
    }

    private func openYouTube() {
        guard let playlist = video?.playlist else { return }

        let youtubeLink = playlist.youtubeURL != nil ? playlist.youtubeURL! : "www.youtube.com"

        if let youtubeURL = URL(string: "youtube://\(youtubeLink)"),
            UIApplication.shared.canOpenURL(youtubeURL) {
            // Open in YouTube app if installed
            print("Opening YouTube App.")
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)

        } else if let youtubeURL = URL(string: "https://\(youtubeLink)") {
            // Open in Safari if YouTube app is not installed
            print("Opening YouTube in Safari.")
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
        }
    }
}

#Preview {
    YouTubeButton()
}
