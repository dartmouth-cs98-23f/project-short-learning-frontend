//
//  Friend.swift
//  Discite
//
//  Created by Jessie Li on 11/12/23.
//

import Foundation

struct Friend: Codable, Identifiable, Hashable {
    var id: String
    var username: String
    var firstName: String
    var lastName: String
    var profileImage: String?
    var roles: [CGFloat]
}
