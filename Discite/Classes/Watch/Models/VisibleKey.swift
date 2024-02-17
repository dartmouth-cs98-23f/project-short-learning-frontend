//
//  VisibleKey.swift
//  Discite
//
//  Created by Jessie Li on 2/16/24.
//

import SwiftUI

struct VisibleKey: PreferenceKey {
    typealias Value = Bool
    
    static var defaultValue = false
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}
