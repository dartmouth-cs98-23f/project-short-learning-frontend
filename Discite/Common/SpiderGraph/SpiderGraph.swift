//
//  SpiderGraph.swift
//  Discite
//
//  Created by Jessie Li on 2/1/24.
//
//  Based on:
//      https://github.com/dadalar/DDSpiderChart
//

import SwiftUI

struct SpiderGraphEntryView: View {
    let center: CGPoint
    let radius: CGFloat
    let values: [CGFloat]
    let color: Color
    
    let count: Int
    
    @State private var appeared = false
    @State private var scale = 0.5
    @State private var opacity = 0.0
    
    init(center: CGPoint, radius: CGFloat, values: [CGFloat], color: Color) {
        self.center = center
        self.radius = radius
        self.values = values
        self.color = color
        
        count = values.count
    }
    
    var body: some View {
        Path { path in
            for i in 0..<values.count {
                let angle = -.pi / 2 - CGFloat(i) * 2 * .pi / CGFloat(values.count)
                let x = center.x + radius * values[i] * cos(angle)
                let y = center.y + radius * values[i] * sin(angle)
                let point = CGPoint(x: x, y: y)
                
                if i == 0 {
                    path.move(to: point)
                } else {
                    path.addLine(to: point)
                }
            }
            
            path.closeSubpath()
        }
        .stroke(color, lineWidth: 2)
        .fill(color.opacity(0.5))
        .scaleEffect(scale)
        .opacity(opacity)
        .onAppear {
            withAnimation(.spring(duration: 1)) {
                scale = 1.0
                opacity = 1.0
        }}

    }
    
}

struct SpiderGraph: View {
    private let axes: [String]
    private let values: [SpiderGraphEntry]
    private let color: Color
    private let circleCount: Int
    private let circleGap: CGFloat
    private let endLineCircles: Bool
    private let fontTitle: Font
    private let textColor: Color
    
    private let center: CGPoint
    private let radius: CGFloat
    private let numAxes: Int
    
    private let layers = 4
    
    @State private var scale = 0.1
    
    public init(axes: [String] = [],
                values: [SpiderGraphEntry] = [],
                color: Color = .grayNeutral,
                circleCount: Int = 10,
                circleGap: CGFloat = 10,
                endLineCircles: Bool = true,
                fontTitle: Font = .body1,
                textColor: Color = .primaryBlueBlack,
                center: CGPoint = CGPoint(x: 0, y: 0),
                radius: CGFloat = 100) {
        
        self.axes = axes
        self.values = values
        self.color = color
        self.circleCount = circleCount
        self.circleGap = circleGap
        self.endLineCircles = endLineCircles
        self.fontTitle = fontTitle
        self.textColor = textColor
        
        self.center = center
        self.radius = radius
        numAxes = axes.count
    }
    
    var body: some View {
        ZStack {
            
            ForEach(0..<layers, id: \.self) { i in
                let scale = (1 - CGFloat(i) / 4.0)
                spiderGraphBase(size: scale * radius)
            }
            
            drawLabels()
            
            ForEach(0..<values.count, id: \.self) { i in
                let entry = values[i]
                SpiderGraphEntryView(center: center,
                                     radius: radius,
                                     values: entry.values,
                                     color: entry.color)
            }

        }
    
    }
    
    // Draws the polygon base of the graph
    func spiderGraphBase(size: CGFloat) -> some View {
        let sides = Double(numAxes)
        let increment = 2.0 * .pi / sides
        
        return Path { path in
            for i in 0..<numAxes+1 {
                let angle = Double(i) * increment + .pi / sides
                let x = size * cos(angle) + center.x
                let y = size * sin(angle) + center.y
                let point = CGPoint(x: x, y: y)
                
                if i == 0 {
                    path.move(to: point)
                } else {
                    path.addLine(to: point)
                }
                
                // Draws lines from the center to the corners
                if i < numAxes {
                    path.move(to: center)
                    path.addLine(to: point)
                }

            }
            
            path.closeSubpath()
        }
        .stroke(color, lineWidth: 1)
    }
    
    func drawLabels() -> some View {
        let sides = Double(numAxes)
        let increment = 2.0 * .pi / sides
        
        return Group {
            ForEach(0..<numAxes, id: \.self) { i in
                let angle = Double(i) * increment + .pi / sides
                
                let isOnTop = sin(angle) < 0 // draw text on top of the circle
                let isOnLeft = cos(angle) < 0 // draw text on the left
                
                let isXOffset = abs(cos(angle)) > 0.0001
                let isYOffset = abs(sin(angle)) > 0.0001

                let labelSize = axes[i].size()
                let labelPadding = 10.0
                
                let xOffset = labelPadding + labelSize.width/2
                let yOffset = labelPadding + labelSize.height/2

                let trueXOffset = (isXOffset ? (isOnLeft ? -xOffset : xOffset) : 0)
                let trueYOffset = (isYOffset ? (isOnTop ? -yOffset : yOffset) : 0)
                
                let labelPosition = CGPoint(
                    x: center.x + radius * cos(angle) + trueXOffset,
                    y: center.y + radius * sin(angle) + trueYOffset)
            
                Text(axes[i])
                    .font(Font.subtitle2)
                    .foregroundColor(textColor)
                    .position(labelPosition)
            }
        }
    
    }
    
}

extension String {
    public func size() -> CGSize {
        return (self as NSString).size()
    }
}

public struct SpiderGraphEntry {
    var values: [CGFloat]
    var color: Color
}
