//
//  AppComponent.swift
//  App
//
//  Created by kimnahun on 2026-01-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Data
import Domain
import RootFeature

import RIBs

final class AppComponent: Component<EmptyDependency>, RootDependency {
    var homeUsecase: HomeUsecaseProtocol {
        let homeRepository = HomeRepository(homeService: makeHomeService(tokenProvider: tokenProvider))
        return HomeUsecase(repository: homeRepository)
    }

    var tokenProvider: TokenProviding {
        shared { TokenRepositoryFactory.makeTokenProvider() }
    }

    init() {
        super.init(dependency: EmptyComponent())
    }
}
