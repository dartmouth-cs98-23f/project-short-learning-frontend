//
//  FriendViewModel.swift
//  Discite
//
//  Created by Bansharee Ireen on 2/22/24.
//

import Foundation

class FriendViewModel: ObservableObject {
    @Published var error: Error?
    
    // GET spider graph data
    func getUserSpiderGraphData() async -> SpiderGraphData? {
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
            print("Error: \(error)")
            return nil
        }
    }
}
