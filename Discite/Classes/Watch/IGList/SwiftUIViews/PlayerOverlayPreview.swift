//
//  PlayerOverlayPreview.swift
//  IGTest
//
//  Created by Jessie Li on 3/6/24.
//

import SwiftUI

struct PlayerOverlayPreview: View {
    var body: some View {
        PlayerControlsPreviewRep()
            .edgesIgnoringSafeArea(.vertical)
            .frame(width: .infinity, height: .infinity)
    }
}

struct PlayerPreview: UIViewRepresentable {
    func makeUIView(context: Context) -> PlayerOverlayView {
        return PlayerOverlayView()
    }
    
    func updateUIView(_ uiView: PlayerOverlayView, context: Context) {
        
    }
}

struct PlayerControlsPreviewRep: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some PlayerOverlayViewController {
        return PlayerOverlayViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

#Preview {
    PlayerOverlayPreview()
        .environment(TabSelectionManager(selection: .Watch))
}
