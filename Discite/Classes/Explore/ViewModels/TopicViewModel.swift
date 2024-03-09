//
//  TopicViewModel.swift
//  Discite
//
//  Created by Jessie Li on 2/14/24.
//

import Foundation

class TopicViewModel: ObservableObject {
    @Published var topic: Topic?
    @Published var state: ViewModelState = .loading
    @Published var toast: Toast?
    
    @Published var playlists: [PlaylistPreview] = []
    @Published var graphValues: [CGFloat] = [0, 0, 0, 0, 0, 0]
    @Published var description: String = "No description available."
    
    var userGraphValues: [CGFloat] = [0, 0, 0, 0, 0, 0]
    
    let roles: [String] = ["Front", "Backend", "ML", "AI/Data", "DevOps", "QA"]
    
    private var task: Task<Void, Error>? {
        willSet {
            if let currentTask = task {
                if currentTask.isCancelled { return }
                currentTask.cancel()
                // Setting a new task cancelling the current task
            }
        }
    }
    
    init(topicId: String) {
        task = Task {
            await getUserGraphValues()
            await getTopic(topicId: topicId)
        }
    }
    
    @MainActor
    public func getTopic(topicId: String) async {
        self.state = .loading
        let query = URLQueryItem(name: "topicId", value: topicId)
        
        do {
            let path = "/api/explore/topicpage/\(topicId)"
            
            let response = try await APIRequest<EmptyRequest, GetTopicResponse>
                .apiRequest(method: .get,
                        authorized: true,
                        path: path,
                        queryItems: [query])
            
            self.playlists = response.videos
            self.graphValues = response.graphValues
            state = .loaded
            
        } catch {
            self.state = .error(error: TopicError.getTopic)
            print("Error in TopicViewModel.getTopic: \(error)")
        }
    }
    
    @MainActor
    public func mockGetTopic(topicId: String) async {
        self.state = .loading
        
        do {
            let path = "/api/topics/\(topicId)"
            
            topic = try await APIRequest<EmptyRequest, Topic>
                .mockRequest(method: .get,
                        authorized: true,
                        path: path)
            
            state = .loaded
            
        } catch {
            self.state = .error(error: TopicError.getTopic)
            print("Error in TopicViewModel.mockGetTopic: \(error)")
        }
    }
    
    @MainActor
    public func mockGetTopicWithQuery(topicId: String) async {
        self.state = .loading
        let query = URLQueryItem(name: "topicId", value: topicId)
        
        do {
            let path = "/api/topics"
            
            topic = try await APIRequest<EmptyRequest, Topic>
                .mockRequest(method: .get,
                        authorized: true,
                        path: path,
                        queryItems: [query])
            
            state = .loaded
            
        } catch {
            self.state = .error(error: TopicError.getTopic)
            print("Error in TopicViewModel.getTopic: \(error)")
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
            
            toast = Toast(style: .success, message: "Saved topic.")
            
        } catch {
            self.state = .error(error: TopicError.saveTopic)
            toast = Toast(style: .error, message: "Unable to save topic.")
            print("Error in TopicViewModel.saveTopic: \(error)")
        }
    }
    
    public func getUserGraphValues() async {
        do {
            print("GET /api/dashboard")
            let response = try await APIRequest<EmptyRequest, RolesResponse>
                .apiRequest(method: .get,
                             authorized: true,
                             path: "/api/dashboard")
            
            self.userGraphValues = response.values
            
        } catch {
            print("Error in TopicViewModel.getUserGraphValues: \(error)")
        }
    }
    
    public func makeSpiderGraphEntry(for type: SpiderGraphEntryType) -> SpiderGraphEntry {
        switch type {
        case .topic:
            return SpiderGraphEntry(values: graphValues, color: .secondaryPink)
        case .user:
            return SpiderGraphEntry(values: userGraphValues, color: .primaryPurpleLight)
        }
    }
    
    deinit {
        task?.cancel()
    }
}

enum SpiderGraphEntryType {
    case topic, user
}

enum TopicError: Error {
    case saveTopic
    case getTopic
}

struct SaveTopicRequest: Codable {
    var topicId: String
    var saved: Bool
}

struct GetTopicResponse: Decodable {
    var videos: [PlaylistPreview]
    var graphValues: [CGFloat]
}
