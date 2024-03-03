//
//  AccountViewModel.swift
//  Discite
//
//  Created by Colton Sankey on 11/12/23.
//

import Foundation

class AccountViewModel: ObservableObject {
    @Published var error: Error?
    
    // GET summary statistics
    @MainActor
    func getProgressSummary() async -> [Statistic]? {
        do {
            let response = try await APIRequest<EmptyRequest, ProgressResponse>
                .apiRequest(method: .get,
                            authorized: true,
                            path: "/api/user/statistics")
            
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
        do {
            let response = try await APIRequest<EmptyRequest, RecentTopicsResponse>
                .apiRequest(method: .get,
                            authorized: true,
                            path: "/api/topics/recent")
            
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
        do {
            let response = try await APIRequest<EmptyRequest, RolesResponse>
                .apiRequest(method: .get,
                            authorized: true,
                            path: "/api/user/roles")
            
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

struct ProgressResponse: Codable {
    var statistics: [Statistic]
}
