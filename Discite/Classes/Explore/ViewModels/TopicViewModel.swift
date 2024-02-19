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
    
    public func mockGetTopic(topicId: String) async {
        do {
            let query = URLQueryItem(name: "topicId", value: topicId)
            topic = try await APIRequest<EmptyRequest, Topic>
                .mockRequest(method: .get,
                        authorized: true,
                        path: "/api/topic",
                        queryItems: [query])
        } catch {
            self.error = TopicError.getTopic
            print("Error fetching topic: \(error)")
        }
    }

    public func mockSaveTopic(parameters: SaveTopicRequest) async {
        do {
            print("TEST: POST save topic \(parameters.topicId)")
            _ = try await APIRequest<SaveTopicRequest, EmptyResponse>
                .mockRequest(method: .post,
                             authorized: false,
                             path: "/api/saveTopic",
                             parameters: parameters,
                             headers: [:])
        } catch {
            self.error = TopicError.saveTopic
            print("Error saving topic: \(error)")
        }
    }
}

enum TopicError: Error {
    case saveTopic
    case getTopic
}

struct SaveTopicRequest: Codable {
    var topicId: String
    var saved: Bool
}
