//
//  User.swift
//  Discite
//
//  Created by Jessie Li on 10/31/23.
//

import Foundation

struct User: Codable, Identifiable {
    var id: Int
    var firstName: String
    var lastName: String
    var username: String
    var email: String?
    var password: String?
    var birthDate: Date?
    var lastLoginDate: Date?
    var profilePicture: String?
    var onBoardingStatus: String?
    
    static let anonymousUser = User(id: 0,
                                    firstName: "John",
                                    lastName: "Doe",
                                    username: "johndoe",
                                    email: "johndoe@email.com")
    
    func getFullName() -> String {
        return self.firstName + " " + self.lastName
    }
    
    func getUserName() -> String {
        return self.username
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
