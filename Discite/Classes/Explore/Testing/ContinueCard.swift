//
//  ContinueCard.swift
//  Discite
//
//  Created by Jessie Li on 12/13/23.
//

import SwiftUI

struct ContinueCard: View {
    
    var playlist: Playlist
    
    var body: some View {
        ZStack {
            if let thumbnailURL = playlist.thumbnailURL {
                AsyncImage(url: URL(string: thumbnailURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                    
                } placeholder: {
                    Rectangle()
                        .fill(Color.grayNeutral)
                        .frame(height: 160)
                }
      
            } else {
                Rectangle()
                    .fill(Color.grayNeutral)
                    .frame(height: 160)
            }
  
            Color.black.opacity(0.6)
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Topic").font(.body2)
                    Text(playlist.title).font(.H4)
                    Text("\(playlist.length) videos • \(playlist.currentIndex/playlist.length)% complete").font(.body2)
                }
                
                Spacer()
                continuePlayButton(completed: 3, total: 5)
            }
            .foregroundColor(.secondaryPeachLight)
            .padding(12)
        }
        .frame(maxWidth: .infinity, maxHeight: 160)
        .clipShape(RoundedRectangle(cornerRadius: 10))

    }
    
    func continuePlayButton(completed: Int, total: Int) -> some View {
        ZStack {
            ProgressArc(fractionComplete: Double(completed) / Double(total))
                .stroke(lineWidth: 5)
                .foregroundColor(.primaryPurpleLight)
                .frame(width: 60, height: 60)
            
            AccentPlayButton(action: { }, label: nil)
            .frame(width: 56, height: 56)
            .background(Color.secondaryPeachLight)
            .clipShape(Circle())
        }
    }
}

struct ProgressArc: Shape {
    
    var fractionComplete: Double
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                        radius: rect.height / 2,
                        startAngle: Angle(degrees: 0),
                        endAngle: Angle(degrees: fractionComplete * 360),
                        clockwise: true)
        }
    }
}
