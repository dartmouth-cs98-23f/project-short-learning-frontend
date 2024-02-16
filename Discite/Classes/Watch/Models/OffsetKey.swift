//
//  OffsetKey.swift
//  Discite
//
//  Created by Jessie Li on 2/13/24.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
