//
//  ServicesContainer.swift
//  Discite
//
//  Created by Jessie Li on 3/18/24.
//
//  From:
//      Alexey Naumov
//      ServicesContainer.swift, CountriesSwiftUI
//      24.10.2019
//      https://github.com/nalexn/clean-architecture-swiftui/blob/mvvm/CountriesSwiftUI/Injected/ServicesContainer.swift
//

import Foundation

extension DIContainer {
    struct Services {
        let exploreService: ExploreService2
//        let countriesService: CountriesService
//        let imagesService: ImagesService
//        let userPermissionsService: UserPermissionsService
        init(exploreService: ExploreService2) {
            self.exploreService = exploreService
        }
        
        static var stub: Self {
            .init(exploreService: StubExploreService())
        }
//        init(countriesService: CountriesService,
//             imagesService: ImagesService,
//             userPermissionsService: UserPermissionsService) {
//            self.countriesService = countriesService
//            self.imagesService = imagesService
//            self.userPermissionsService = userPermissionsService
//        }
        
//        static var stub: Self {
//            .init(exploreService: ExploreService2(),
//                  imagesService: StubImagesService(),
//                  userPermissionsService: StubUserPermissionsService())
//        }
    }
}
