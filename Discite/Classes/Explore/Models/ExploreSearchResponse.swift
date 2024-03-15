//
//  ExploreSearchResponse.swift
//  Discite
//
//  Created by Jessie Li on 3/4/24.
//

import Foundation

struct UserSearchResult: Decodable, Identifiable {
    let id: String
    let firstName: String
    let lastName: String
    let username: String
    let email: String
}

struct TopicSearchResult: Decodable, Identifiable {
    let topicId: String
    let topic: String
    let score: Int
    let id: UUID

    enum CodingKeys: String, CodingKey {
        case topic, topicId, score
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.topicId = try container.decode(String.self, forKey: .topicId)
        self.topic = try container.decode(String.self, forKey: .topic)
        self.score = try container.decode(Int.self, forKey: .score)
        self.id = UUID()
    }
}

struct ExploreSearchResponse: Decodable {
    let playlists: [PlaylistPreview]?
    let topics: [TopicSearchResult]?
    let users: [UserSearchResult]?

    enum CodingKeys: String, CodingKey {
        case videos, topics, users
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.topics = try container.decodeIfPresent([TopicSearchResult].self, forKey: .topics)
        self.users = try container.decodeIfPresent([UserSearchResult].self, forKey: .users)
        self.playlists = (try? container.decodeIfPresent([Playlist].self, forKey: .videos))?.map { playlist in
            return PlaylistPreview(playlist: playlist)
        }
    }
}
