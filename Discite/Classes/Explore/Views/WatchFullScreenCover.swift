//
//  WatchFullScreenCover.swift
//  Discite
//
//  Created by Jessie Li on 3/8/24.
//

import SwiftUI

struct WatchFullScreenCover: View {
    @Environment(\.dismiss) var dismiss
    let seed: String?
    
    var body: some View {
        GeometryReader { geo in
            NestedAdapterWatchWrapper(
                size: geo.size,
                safeArea: geo.safeAreaInsets,
                seed: seed
            )
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
        
                    } label: {
                        HStack(alignment: .center, spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back to Explore")
                        }
                        .font(.button)
                        .foregroundStyle(Color.secondaryPeachLight)
                    }
                    .foregroundStyle(Color.secondaryPeachLight)
                }
            }
        }
    }
}

#Preview {
    WatchFullScreenCover(seed: "65d8fc3495f306b28d1b88d6")
    .environment(TabSelectionManager.init(selection: .Explore))
    .environmentObject(User())
}
