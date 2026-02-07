//
//  AppComponent.swift
//  App
//
//  Created by kimnahun on 2026-01-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Data
import Domain
import RIBs
import RootFeature

final class AppComponent: Component<EmptyDependency>, RootDependency {

    var tokenProvider: TokenProviding {
        shared { TokenRepositoryFactory.makeTokenProvider() }
    }

    init() {
        super.init(dependency: EmptyComponent())
    }
}
