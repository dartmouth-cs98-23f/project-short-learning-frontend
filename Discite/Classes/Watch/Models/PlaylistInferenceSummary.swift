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
    
    private enum SectionKey: String, CodingKey {
        case title
        case content
    }
    
    struct Section: Decodable, Identifiable {
        var id: UUID
        var title: String
        var content: [String]
        
        init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<PlaylistInferenceSummary.SectionKey> = try decoder.container(keyedBy: PlaylistInferenceSummary.SectionKey.self)
            
            self.id = UUID()
            self.title = try container.decode(String.self, forKey: PlaylistInferenceSummary.SectionKey.title)
            self.content = try container.decode([String].self, forKey: PlaylistInferenceSummary.SectionKey.content)
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
