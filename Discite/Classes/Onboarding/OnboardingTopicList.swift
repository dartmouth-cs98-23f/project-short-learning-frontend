//
//  OnboardingTopicList.swift
//  Discite
//
//  Created by Jessie Li on 2/27/24.
//

import Foundation

let onboardingTopics: [String: Set<Int>] = [
    "Algorithms": [1, 61],
    "AI/ML": [7, 19],
    "Computer Architecture": [13],
    "Data Science": [19],
    "Databases": [25],
    "UI/UX": [31],
    "Mobile App Development": [49, 37, 43],
    "Web Development": [49, 37, 43],
    "Networks": [43],
    "Programming Languages": [37],
    "Software Engineering": [43],
    "Computer Vision": [55],
    "Theory": [61],
    "Quantum Computing": [67]
]

struct OnboardingTopic: Identifiable, Hashable {
    let id: UUID = UUID()
    let title: String
    var selected: Bool = false
    let values: Set<Int>
    
    static func defaults() -> [OnboardingTopic] {
        return onboardingTopics.map { (title, values) in
            return OnboardingTopic(title: title, values: values)
        }
    }
    
    mutating func toggle() {
        selected.toggle()
    }
}
