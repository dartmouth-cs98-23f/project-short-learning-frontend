//
//  Searchables.swift
//  Discite
//
//  Created by Bansharee Ireen on 2/20/24.
//

import SwiftUI

struct Searchable {
    let id: String
    let name: String
    let type: SearchableType
    let topic: TopicTag?
    let playlist: PlaylistPreview?
}

enum SearchableType {
    case topic
    case playlist
}
