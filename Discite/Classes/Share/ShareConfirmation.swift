//
//  ShareConfirmation.swift
//  Discite
//
//  Created by Jessie Li on 11/13/23.
//

import SwiftUI

struct ShareConfirmation: View {
    
    @Binding var isShowing: Bool
    @State var appeared: Bool = false
    var playlist: Playlist
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 42) {
            Image(systemName: "checkmark")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .addGradient(gradient: LinearGradient.pinkOrangeGradient)
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
                    .addGradient(gradient: LinearGradient.pinkOrangeGradient)
            }
            
            VStack(spacing: 12) {
                // Keep sharing
                PrimaryActionButton(action: { isShowing = false }, label: "Keep learning")
                
                // Continue learning (back to Watch)
                TextualButton(action: { isShowing = false }, label: "Share with more friends")
            }

        }
        .padding([.leading, .trailing], 18)
        
    }
}

#Preview {
    let samplePlaylists = VideoService.fetchTestSequence()!.playlists
    return ShareConfirmation(isShowing: .constant(true), playlist: samplePlaylists[0])
}