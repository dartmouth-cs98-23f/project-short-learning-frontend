//
//  SwipeDirection.swift
//  Discite
//
//  Created by Jessie Li on 10/27/23.
//
//  Source:
//      Case trigger: https://stackoverflow.com/questions/59109138/how-to-implement-a-left-or-right-draggesture-that-trigger-a-switch-case-in-swi
//      Switch on drag gesture: https://stackoverflow.com/questions/60885532/how-to-detect-swiping-up-down-left-and-right-with-swiftui-on-a-view

import SwiftUI

enum SwipeDirection: CaseIterable {
    case up, down, left, right, none
}

func swipeDirection(value: DragGesture.Value) -> SwipeDirection {

    switch(value.translation.width, value.translation.height) {
    case (...0, -30...30):
        return .left
    case (0..., -30...30):
        return .right
    case (-100...100, ...0):
        return .up
    case (-100...100, 0...):
        return .down
    default:
        return .none
    }

}
