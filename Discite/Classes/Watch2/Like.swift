//
//  Like.swift
//  Discite
//
//  Created by Jessie Li on 2/13/24.
//

import Foundation

struct Like: Identifiable {
    var id: UUID = UUID()
    var tappedRect: CGPoint = .zero
    var isAnimated: Bool = false
}
