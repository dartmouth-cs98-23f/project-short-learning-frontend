//
//  UserData.swift
//  Discite
//
//  Created by Jessie Li on 2/28/24.
//

import Foundation

struct UserData: Codable {
    // var userId: String
    var firstName: String
    var lastName: String
    var username: String
    var email: String?
    var profilePicture: String?
    var onBoardingStatus: Bool
}
