//
//  History.swift
//  Discite
//
//  Created by Bansharee Ireen on 2/29/24.
//

import Foundation


struct History: Identifiable, Codable {
    let id: UUID
    let date: Date
    let title: String

    init(id: UUID = UUID(), date: Date = Date(), title: String) {
        self.id = id
        self.date = date
        self.title = title
    }
}
