//
//  Friend.swift
//  Discite
//
//  Created by Jessie Li on 11/12/23.
//

import Foundation

struct Friend: Decodable, Identifiable {
    var id: String
    var username: String
    var firstName: String
    var lastName: String
    var profileImage: String
}
