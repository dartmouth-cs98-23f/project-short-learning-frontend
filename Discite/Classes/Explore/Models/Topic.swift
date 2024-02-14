//
//  Topic.swift
//  Discite
//
//  Created by Jessie Li on 11/9/23.
//

import Foundation

struct Topic: Decodable {

    var _id: String
    var topicName: String
    var subTopicName: String?
    var displayTopicName: String?
    var displaySubtopicName: String?
    var description: String?
    var thumbnailURL: String
    
}
