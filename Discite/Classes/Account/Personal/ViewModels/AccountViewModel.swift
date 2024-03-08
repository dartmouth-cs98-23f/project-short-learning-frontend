//
//  AccountViewModel.swift
//  Discite
//
//  Created by Colton Sankey on 11/12/23.
//  Updated by Bansharee Ireen on 3/7/24.
//

import Foundation

class AccountViewModel: ObservableObject {
    @Published var error: Error?
    
    // PUT user information
    @MainActor
    func updateUser(firstName: String, lastName: String, username: String, profilePicture: String?) async {
        print("PUT /api/user")
        
        do {
            let requestBody = UpdateUserRequest(firstName: firstName, lastName: lastName, profilePicture: profilePicture)

            _ = try await APIRequest<UpdateUserRequest, EmptyResponse>
                .apiRequest(method: .put,
                            authorized: true,
                            path: "/api/user",
                            parameters: requestBody)
        } catch {
            self.error = error
            print("Error in AccountViewModel.updateUser: \(error)")
        }
    }
    
    // GET summary statistics
    @MainActor
    func getProgressSummary() async -> [Statistic]? {
        print("GET /api/statistics")
        
        do {
            let response = try await APIRequest<EmptyRequest, WatchStatisticsResponse>
                .apiRequest(method: .get,
                            authorized: true,
                            path: "/api/statistics")
            
            return response.statistics
            
        } catch {
            self.error = error
            print("Error in AccountViewModel.getProgressSummary: \(error)")
            return nil
        }
    }
    
    // GET recent topics
    @MainActor
    func getRecentTopics() async -> [TopicTag]? {
        print("GET /api/recentTopics")
        
        do {
            let response = try await APIRequest<EmptyRequest, RecentTopicsResponse>
                .apiRequest(method: .get,
                            authorized: true,
                            path: "/api/recentTopics")
            
            return response.topics
            
        } catch {
            self.error = error
            print("Error in AccountViewModel.getRecentTopics: \(error)")
            return nil
        }
    }
    
    // GET spider graph data
    @MainActor
    func getSpiderGraphData() async -> SpiderGraphData? {
        print("GET /api/dashboard")
        
        do {
            let response = try await APIRequest<EmptyRequest, RolesResponse>
                .apiRequest(method: .get,
                            authorized: true,
                            path: "/api/dashboard")
            
            let spiderGraphData = SpiderGraphData(
                data: [SpiderGraphEntry(values: response.values,
                                        color: .primaryPurpleLight)],
                axes: response.roles,
                color: .primaryPurpleLight, titleColor: .gray, bgColor: .white)
            
            return spiderGraphData
            
        } catch {
            self.error = error
            print("Error in AccountViewModel.getSpiderGraphData: \(error)")
            return nil
        }
    }
    
    func logout() {
        Auth.shared.logout()
    }
}

struct RolesResponse: Codable {
    var roles: [String]
    var values: [CGFloat]
}

struct RecentTopicsResponse: Codable {
    var topics: [TopicTag]
}

struct WatchStatisticsResponse: Codable {
    var statistics: [Statistic]
}
