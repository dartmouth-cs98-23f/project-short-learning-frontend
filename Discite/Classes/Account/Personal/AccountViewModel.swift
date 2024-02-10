//
//  AccountViewModel.swift
//  Discite
//
//  Created by Colton Sankey on 11/12/23.
//

import Foundation

class AccountViewModel: ObservableObject {
    
    // GET summary statistics
    func getProgressSummary() async -> [Statistic]? {
        do {
            let response = try await APIRequest<EmptyRequest, ProgressResponse>
                .mockRequest(method: .get,
                            authorized: false,
                            path: "/api/statistics")
            
            return response.statistics
            
        } catch {
            print("Error: \(error)")
            return nil
        }
    }
    
    // GET recent topics
    func getRecentTopics() async -> [TopicTag]? {
        do {
            let response = try await APIRequest<EmptyRequest, RecentTopicsResponse>
                .mockRequest(method: .get,
                            authorized: false,
                            path: "/api/recentTopics")
            
            return response.topics
            
        } catch {
            print("Error: \(error)")
            return nil
        }
    }
    
    // GET spider graph data
    func getSpiderGraphData() async -> SpiderGraphData? {
        do {
            let response = try await APIRequest<EmptyRequest, RolesResponse>
                .mockRequest(method: .get,
                            authorized: false,
                            path: "/api/roles")
            
            let spiderGraphData = SpiderGraphData(
                data: [SpiderGraphEntry(values: response.values,
                                        color: .primaryPurpleLight)],
                axes: response.roles,
                color: .primaryPurpleLight, titleColor: .gray, bgColor: .white)
            
            return spiderGraphData
            
        } catch {
            print("Error: \(error)")
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
