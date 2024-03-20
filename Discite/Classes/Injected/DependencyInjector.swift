//
//  DependencyInjector.swift
//  Discite
//
//  Created by Jessie Li on 3/18/24.
//
//  From:
//      Alexey Naumov
//      DependencyInjector.swift, CountriesSwiftUI
//      28.10.2019
//      https://github.com/nalexn/clean-architecture-swiftui/blob/master/CountriesSwiftUI/Injected/DependencyInjector.swift
//

import SwiftUI
import Combine

// MARK: - DIContainer

struct DIContainer: EnvironmentKey {
    
    let appState: AppState
    let services: Services
    
    static var defaultValue: Self { Self.default }
    
    private static let `default` = DIContainer(appState: AppState(), services: .stub)
    
    init(appState: AppState, services: DIContainer.Services) {
        self.appState = appState
        self.services = services
    }
}

#if DEBUG
extension DIContainer {
    static var preview: Self {
        .init(appState: AppState.preview, services: .stub)
    }
}
#endif
