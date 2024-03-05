//
//  FilterFriends.swift
//  Discite
//
//  Created by Bansharee Ireen on 2/16/24.
//

import Foundation

func filteredFriends(friendsList: [Friend]?, searchText: String) -> [Friend] {
    guard let friends = friendsList else { return [] }
    if searchText.isEmpty {
        return friends
    } else {
        return friends.filter { friend in
            friend.username.localizedCaseInsensitiveContains(searchText) ||
            (friend.firstName + " " + friend.lastName).localizedCaseInsensitiveContains(searchText)
        }
    }
}
