//
//  ViewModelState.swift
//  Discite
//
//  Created by Jessie Li on 3/3/24.
//

import Foundation

public enum ViewModelState {
    case loading
    case loaded
    case error(error: Error)
}
