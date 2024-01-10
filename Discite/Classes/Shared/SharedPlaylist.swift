//
//  SharedPlaylist.swift
//  Discite
//
//  Created by Jessie Li on 11/12/23.
//

import Foundation

struct SharedPlaylist: Decodable, Identifiable {
    var id: String
    var playlist: Playlist
    var sender: Friend?
    var receiver: Friend?
    var hasWatched: Bool
}
