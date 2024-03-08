//
//  UpdateUserRequest.swift
//  Discite
//
//  Created by Bansharee Ireen on 3/7/24.
//

import Foundation

struct UpdateUserRequest: Encodable {
    let firstName: String
    let lastName: String
    let username: String
    let profilePicture: String?
}
