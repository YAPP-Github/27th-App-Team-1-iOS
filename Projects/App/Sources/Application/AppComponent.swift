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
    private var travelTemplateRepository: TravelTemplateRepositoryInterface {
        let service = makeTravelTemplateService(tokenProvider: tokenProvider)
        return TravelTemplateRepository(service: service)
    }
    
    private var travelProgramRepository: TravelProgramRepositoryInterface {
        let service = makeTravelProgramService()
        return TravelProgramRepository(service: service)
    }
    
    private var userTravelRepository: UserTravelRepositoryInterface {
        let service = makeUserTravelService(tokenProvider: tokenProvider)
        return UserTravelRepository(service: service)
    }
    
    var homeUsecase: HomeUsecaseProtocol {
        return HomeUsecase(
            travelTemplateRepository: travelTemplateRepository,
            travelRepository: travelProgramRepository,
            userTravelRepository: userTravelRepository
        )
    }

    var tokenProvider: TokenProviding {
        shared { TokenRepositoryFactory.makeTokenProvider() }
    }

    init() {
        super.init(dependency: EmptyComponent())
    }
}
