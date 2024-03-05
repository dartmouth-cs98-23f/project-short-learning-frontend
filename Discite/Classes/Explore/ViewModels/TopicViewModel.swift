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
    
    @MainActor
    public func getTopic(topicId: String) async {
        do {
            let path = "/api/topics/\(topicId)"
            
            topic = try await APIRequest<EmptyRequest, Topic>
                .apiRequest(method: .get,
                        authorized: true,
                        path: path)
        } catch {
            self.error = TopicError.getTopic
            print("Error in TopicViewModel.getTopic: \(error)")
        }
    }
    
    @MainActor
    public func mockGetTopic(topicId: String) async {
        do {
            let path = "/api/topics/\(topicId)"
            
            topic = try await APIRequest<EmptyRequest, Topic>
                .mockRequest(method: .get,
                        authorized: true,
                        path: path)
        } catch {
            self.error = TopicError.getTopic
            print("Error in TopicViewModel.mockGetTopic: \(error)")
        }
    }

    @MainActor
    public func saveTopic(parameters: SaveTopicRequest) async {
        do {
            print("POST save topic \(parameters.topicId)")
            let path = "/api/save/topics/\(parameters.topicId)"
            
            _ = try await APIRequest<SaveTopicRequest, EmptyResponse>
                .apiRequest(method: .post,
                             authorized: true,
                             path: path,
                             parameters: parameters)
            
        } catch {
            self.error = TopicError.saveTopic
            print("Error in TopicViewModel.saveTopic: \(error)")
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
