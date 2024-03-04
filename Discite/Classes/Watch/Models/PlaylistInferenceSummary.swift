//
//  PlaylistSummaryResponse.swift
//  Discite
//
//  Created by Jessie Li on 3/3/24.
//

import Foundation

struct PlaylistInferenceSummary: Decodable {
    enum RootKey: String, CodingKey {
        case summary
    }
    
    enum SummaryKey: String, CodingKey {
        case inferenceSummary
    }
    
    enum InferenceKey: String, CodingKey {
        case introduction, sections, topics, generalTopics
    }
    
    struct Section: Decodable, Identifiable {
        var id: UUID
        var title: String
        var content: [String]
        
        enum CodingKeys: CodingKey {
            case title
            case content
        }
        
        init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<PlaylistInferenceSummary.Section.CodingKeys> = try decoder.container(keyedBy: PlaylistInferenceSummary.Section.CodingKeys.self)
            
            self.id = UUID()
            self.title = try container.decode(String.self, forKey: PlaylistInferenceSummary.Section.CodingKeys.title)
            self.content = try container.decode([String].self, forKey: PlaylistInferenceSummary.Section.CodingKeys.content)
        }
    }
    
    struct GeneralTopic: Decodable {
        var name: String
        var complexity: Double
    }
    
    let introduction: String
    let sections: [Section]
    let topics: [String]
    let generalTopics: [GeneralTopic]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let summary = try container.nestedContainer(keyedBy: SummaryKey.self, forKey: .summary)
        let inference = try summary.nestedContainer(keyedBy: InferenceKey.self, forKey: .inferenceSummary)
        
        introduction = try inference.decode(String.self, forKey: .introduction)
        sections = try inference.decode([Section].self, forKey: .sections)
        topics = try inference.decode([String].self, forKey: .topics)
        generalTopics = try inference.decode([GeneralTopic].self, forKey: .generalTopics)

        }
}
