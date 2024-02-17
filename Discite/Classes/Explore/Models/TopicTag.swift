//
//  TopicTag.swift
//  Discite
//
//  Created by Jessie Li on 1/21/24.
//

import Foundation
import SwiftUI

struct TopicTag: Codable, Identifiable {
    var id: String
    var topicName: String
    var isSaved: Bool
    
    enum CodingKeys: String, CodingKey {
        case topicName
        case id = "topicId"
        case isSaved
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.topicName = try container.decode(String.self, forKey: .topicName)
        self.id = try container.decode(String.self, forKey: .id)
        self.isSaved = try container.decode(Bool.self, forKey: .isSaved)
    }
}
