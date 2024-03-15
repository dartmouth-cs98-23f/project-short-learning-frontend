//
//  AccountViewModel.swift
//  Discite
//
//  Created by Colton Sankey on 11/12/23.
//

import Foundation

@MainActor
class AccountViewModel: ObservableObject {
    @Published var error: Error?

    // GET summary statistics
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
