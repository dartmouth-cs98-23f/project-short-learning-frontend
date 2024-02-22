//
//  AddToHistory.swift
//  Discite
//
//  Created by Bansharee Ireen on 2/21/24.
//

import SwiftUI

func addToHistory(searchHistory: inout [String], searchItem: String) {
    searchHistory.append(searchItem)
}