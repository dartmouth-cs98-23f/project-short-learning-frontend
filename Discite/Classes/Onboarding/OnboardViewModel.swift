//
//  OnboardViewModel.swift
//  Discite
//
//  Created by Jessie Li on 2/23/24.
//

import Foundation

@MainActor
class OnboardViewModel: ObservableObject {
    @Published var error: Error?

    // experience
    @Published var complexity: Double = 0.50

    // topics
    @Published var topics: [OnboardingTopic] = OnboardingTopic.defaults()

    // spider
    @Published var resetGraph: Bool = false
    var values: [CGFloat] = [0.8, 0.8, 1.0, 0.7, 0.9, 0.75]
    let defaultValues: [CGFloat] = [0.8, 0.8, 1.0, 0.7, 0.9, 0.75]
    let roles: [String] = ["Front", "Backend", "ML", "AI/Data", "DevOps", "QA"]

    public func resetGraphValues() {
        values = defaultValues
        resetGraph.toggle()
    }

    // POST onboarding
    public func onboard(user: User) async {
        error = nil

        let filteredTopics = topics.compactMap { topic in
            topic.selected ? topic.values : nil
        }.flatMap { $0 }

        let onboardRequest = OnboardRolesRequest(complexity: complexity,
                                                 topics: Set(filteredTopics),
                                                 roles: roles,
                                                 values: values)

        do {
            print("POST onboard")
            values = rotateValues(values: values)
            _ = try await APIRequest<OnboardRolesRequest, EmptyResponse>
                .apiRequest(method: .post,
                             authorized: true,
                             path: "/api/user/onboarding",
                             parameters: onboardRequest)

            user.completeOnboarding()

        } catch {
            self.error = error
            print("Error in OnboardViewModel.onboard: \(error)")
        }
    }

    private func rotateValues(values: [CGFloat]) -> [CGFloat] {
        let count = values.count

        if count <= 1 {
            return values
        }

        return values.prefix(count - 1).reversed() + [values[count - 1]]
    }
}

struct OnboardRolesRequest: Codable {
    var complexity: Double
    var topics: Set<Int>
    var roles: [String]
    var values: [CGFloat]
}
