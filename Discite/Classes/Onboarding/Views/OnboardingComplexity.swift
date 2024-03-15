//
//  OnboardingComplexity.swift
//  Discite
//
//  Created by Jessie Li on 2/27/24.
//

import SwiftUI

struct OnboardingComplexity: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: OnboardViewModel

    var body: some View {
        let color = Color.interpolate(from: .primaryBlueNavy,
                                      to: .secondaryPurplePinkLight,
                                      value: viewModel.complexity)

        VStack(spacing: 24) {
            // header
            VStack(alignment: .leading, spacing: 4) {
                Text("Experience")
                    .font(.H2)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("Estimate your overall computer science skill level on a scale of 0 to 1.")
                    .font(.body1)
            }

            Spacer()

            // slider
            VStack(spacing: 12) {
                Text(String(format: "%.2f", viewModel.complexity))
                    .font(.extraBig)
                    .foregroundStyle(color)
                    .animation(.smooth, value: viewModel.complexity)

                Slider(value: $viewModel.complexity, in: 0...1, step: 0.01) {
                } minimumValueLabel: {
                        Text("0")
                } maximumValueLabel: {
                    Text("1")
                }
                .tint(color)
            }

            // key
            legend()

            Spacer()

        }
        .padding(.vertical, 24)
        .padding(.horizontal, 18)
        .navigationBarBackButtonHidden(true)
    }

    @ViewBuilder
    func legend() -> some View {
        VStack(alignment: .leading) {
            let currComplexity = Complexity.complexity(for: viewModel.complexity)
            
            ForEach(0..<5, id: \.self) { i in
                let val = Double(i) / 5
                
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
    OnboardingComplexity(viewModel: OnboardViewModel())
}
