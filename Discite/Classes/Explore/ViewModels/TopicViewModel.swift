//
//  TopicViewModel.swift
//  Discite
//
//  Created by Jessie Li on 2/14/24.
//

import Foundation

class TopicViewModel: ObservableObject {
    @Published var topic: Topic?
    @Published var error: Error? 
    
    init() { }
    
    func getTopic(topicId: String) async {
        do {
            let query = URLQueryItem(name: "topicId", value: topicId)
            topic = try await APIRequest<EmptyRequest, Topic>
                .mockRequest(method: .get,
                        authorized: true,
                        path: "/api/topic",
                        queryItems: [query])
        } catch {
            self.error = error
            print("Error fetching topic: \(error)")
        }
    }
}
