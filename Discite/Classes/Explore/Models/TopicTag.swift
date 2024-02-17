//
//  TopicTag.swift
//  Discite
//
//  Created by Jessie Li on 1/21/24.
//

import Foundation
import SwiftUI

struct TopicTag: Codable, Identifiable {
    var id: UUID
    var topicId: String
    var topicName: String
    var isSaved: Bool
    
    enum CodingKeys: String, CodingKey {
        case topicName
        case topicId
        case isSaved
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = UUID()
        self.topicId = try container.decode(String.self, forKey: .topicId)
        self.topicName = try container.decode(String.self, forKey: .topicName)
        self.isSaved = try container.decode(Bool.self, forKey: .isSaved)
    }
}
