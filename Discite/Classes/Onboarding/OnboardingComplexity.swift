//
//  OnboardingComplexity.swift
//  Discite
//
//  Created by Jessie Li on 2/27/24.
//

import SwiftUI

struct OnboardingComplexity: View {
    @State private var value: Double = 0.5
    
    var body: some View {
        let color = Color.interpolate(from: .primaryBlueNavy,
                                      to: .secondaryPurplePinkLight,
                                      value: value)
        
        VStack(spacing: 24) {
            // header
            VStack(alignment: .leading, spacing: 12) {
                Text("Complexity")
                    .font(.H2)
                
                Text("Pick a complexity value that agrees with your computer science background.")
                    .font(.body1)
            }
            
            Spacer()
            
            // slider
            VStack(spacing: 12) {
                Text(String(format: "%.2f", value))
                    .font(.extraBig)
                    .foregroundStyle(color)
                    .animation(.smooth, value: value)
                
                Slider(value: $value, in: 0...1, step: 0.01) {
                } minimumValueLabel: {
                        Text("0")
                } maximumValueLabel: {
                    Text("1")
                }
                .padding()
                .tint(color)
            }
            
            // key
            legend()
            
            Spacer()
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 48)
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    @ViewBuilder
    func legend() -> some View {
        VStack(alignment: .leading) {
            let currComplexity = Complexity.complexity(for: value)
            
            ForEach(0..<5, id: \.self) { i in
                let val = Double(i)/5
                
                let complexity = Complexity.complexity(for: val)
                
                let color = Color.interpolate(
                    from: .primaryBlueNavy,
                    to: .secondaryPurplePinkLight,
                    value: val)
                
                HStack {
                    Circle()
                        .fill(color)
                        .frame(width: (currComplexity == complexity) ? 12 : 8)
                    
                    Text(complexity.label)
                        .font(currComplexity == complexity ? .subtitle1 : .body2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(currComplexity == complexity ?
                                         color : Color.grayDark)
                }
                .animation(.smooth(duration: 0.2), value: currComplexity == complexity)
            }
            
            // prevents key from shifting when last item is reached
            Circle()
                .fill(.clear)
                .frame(width: 4)

        }

        .frame(minHeight: 170)
    }
    
}

enum Complexity: CaseIterable {
    case beginner, highschool, college, professional, expert
    
    static func complexity(for value: Double) -> Complexity {
        switch value {
        case 0.0..<0.2:
            return .beginner
        case 0.2..<0.4:
            return .highschool
        case 0.4..<0.6:
            return .college
        case 0.6..<0.8:
            return .professional
        case 0.8...1.0:
            return .expert
        default:
            fatalError("Invalid value")
        }
    }
    
    var label: String {
        switch self {
        case .beginner:
            return "0.00 - 0.19 Beginner"
        case .highschool:
            return "0.20 - 0.39 High school"
        case .college:
            return "0.40 - 0.59 College"
        case .professional:
            return "0.60- 0.79 Professional"
        case .expert:
            return "0.80- 1.00 Expert"
        }
    }
}

#Preview {
    OnboardingComplexity()
}
