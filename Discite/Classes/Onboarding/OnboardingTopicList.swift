//
//  OnboardingTopicList.swift
//  Discite
//
//  Created by Jessie Li on 2/27/24.
//

import Foundation

let onboardingTopics = [
    "Algorithms",
    "UI/UX",
    "AI/ML",
    "Cybersecurity",
    "Mobile App Development",
    "Web Development",
    "Databases",
    "Networks",
    "Cloud",
    "Operating Systems",
    "Data Science",
    "Computer Vision",
    "Quantum Computing"
]

struct OnboardingTopic: Identifiable, Hashable {
    let id: UUID = UUID()
    let title: String
    var selected: Bool = false
    
    static func defaults() -> [OnboardingTopic] {
        return onboardingTopics.map { topic in
            return OnboardingTopic(title: topic)
        }
    }
    
    mutating func toggle() {
        selected.toggle()
    }
}

class OnboardingTopic1: Identifiable, ObservableObject {
    let id: UUID = UUID()
    let title: String
    var selected: Bool
    
    init(title: String, selected: Bool = false) {
        self.title = title
        self.selected = selected
    }
    
    static func defaults() -> [OnboardingTopic] {
        return onboardingTopics.map { topic in
            return OnboardingTopic(title: topic)
        }
    }
}
