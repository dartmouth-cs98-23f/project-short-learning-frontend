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
                                    firstName: "John",
                                    lastName: "Doe",
                                    userName: "johndoe",
                                    email: "johndoe@email.com")
    
    func getFullName() -> String {
        return self.firstName + " " + self.lastName
    }
    
    func getUserName() -> String {
        return self.userName
    }
}

struct Statistic: Codable, Identifiable {
    var id: String?
    var value: String
    var item: String
    var timeframe: String
    
    enum CodingKeys: String, CodingKey {
        case value
        case item
        case timeframe
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.value = try container.decode(String.self, forKey: .value)
        self.item = try container.decode(String.self, forKey: .item)
        self.timeframe = try container.decode(String.self, forKey: .timeframe)
        
        self.id = UUID().uuidString
    }
}
