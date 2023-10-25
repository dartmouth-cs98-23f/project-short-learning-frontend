//
//  SidebarItem.swift
//  Discite
//
//  Created by Jessie Li on 10/23/23.
//

enum SidebarItem: Int, CaseIterable {
    case watch, topics, shared, account
    
    var title: String {
        switch self {
        case .watch:
            return "Watch"
        case .topics:
            return "My Topics"
        case .shared:
            return "Shared"
        case .account:
            return "Account"
        }
    }
}
