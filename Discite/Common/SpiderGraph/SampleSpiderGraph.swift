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

struct SpiderGraphData {
    var data: [SpiderGraphEntry]
    var axes: [String]
    var color: Color
    var titleColor: Color
    var bgColor: Color
}

struct SpiderGraphView: View {
    @State var currentSample = SpiderGraphData(
        data: [SpiderGraphEntry(values: [0.8, 0.8, 1.0, 0.7, 0.9, 0.75],
                                color: .primaryPurpleLight)],
        axes: ["Frontend", "Backend", "ML", "AI/Data", "DevOps", "QA"],
        color: .primaryPurpleLight, titleColor: .gray, bgColor: .white)
    
    var body: some View {
        GeometryReader { geometry in
            
            let center = CGPoint(x: geometry.size.width/2, y: geometry.size.height/2)
            
            ZStack {

                SpiderGraph(
                    axes: currentSample.axes,
                    values: currentSample.data,
                    textColor: currentSample.titleColor,
                    center: center,
                    radius: 125
                )
            }
        }
    }
}

#Preview {
    SpiderGraphView()
}
