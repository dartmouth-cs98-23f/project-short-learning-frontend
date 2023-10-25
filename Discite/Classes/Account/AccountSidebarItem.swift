//
//  AccountSidebarItem.swift
//  Discite
//
//  Created by Jessie Li on 10/23/23.
//

enum AccountSidebarItem: Int, CaseIterable {
    case posts, friends, settings
    
    var title: String {
        switch self {
        case .posts:
            return "My Posts"
        case .friends:
            return "Friends"
        case .settings:
            return "Settings"
        }
    }
}
