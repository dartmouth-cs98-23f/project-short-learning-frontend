//
//  User.swift
//  Discite
//
//  Created by Jessie Li on 10/31/23.
//

import Foundation

struct User: Codable {
    var userId: Int
    var firstName: String
    var lastName: String
    var userName: String
    var email: String
    var passwordHash: String?
    var dateOfBirth: Date?
    var RegistrationDate: Date?
    var lastLogin: Date?
    var profilePicture: String?
    var onBoardingStatus: String?
    
    static let anonymousUser = User(userId: 0,
                                    firstName: "FirstName",
                                    lastName: "LastName",
                                    userName: "anonymous",
                                    email: "anonymous@email.com")
    
    func getFullName() -> String {
        return self.firstName + " " + self.lastName
    }
    
    func getUserName() -> String {
        return self.userName
    }
}
