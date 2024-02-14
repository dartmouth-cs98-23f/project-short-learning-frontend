//
//  TopicViewModel.swift
//  Discite
//
//  Created by Jessie Li on 2/14/24.
//

import Foundation

class TopicViewModel: ObservableObject {
    @Published var topic: Topic?
    
    init() { }
}
