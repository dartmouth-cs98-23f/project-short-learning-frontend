//
//  User.swift
//  Discite
//
//  Created by Jessie Li on 10/31/23.
//

import Foundation

struct User: Codable, Identifiable {
    var id: UUID
    var userId: String
    var firstName: String
    var lastName: String
    var username: String
    var email: String?
    var password: String?
    var profilePicture: String?
    var onboarded: Bool
    
    enum CodingKeys: String, CodingKey {
        case userId = "id"
        case firstName
        case lastName
        case username
        case email
        case password
        case profilePicture
        case onboarded = "onBoardingStatus"
    }
    
    init(userId: String, firstName: String, lastName: String, username: String, email: String) {
        self.id = UUID()
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.email = email
        self.onboarded = false
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = UUID()
        self.userId = try container.decode(String.self, forKey: .userId)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.username = try container.decode(String.self, forKey: .username)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.password = try container.decodeIfPresent(String.self, forKey: .password)
        self.profilePicture = try container.decodeIfPresent(String.self, forKey: .profilePicture)
        
        let stringOnboardingStatus = try container.decode(String.self, forKey: .onboarded)
        self.onboarded = (stringOnboardingStatus == "complete")
    }
    
    static let anonymousUser = User(userId: "abc123",
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
