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
        shared {
            let service = makeTravelTemplateService(tokenProvider: tokenProvider)
            return TravelTemplateRepository(service: service)
        }
    }
    
    private var travelProgramRepository: TravelProgramRepositoryInterface {
        shared {
            let service = makeTravelProgramService()
            return TravelProgramRepository(service: service)
        }
    }
    
    private var userTravelRepository: UserTravelRepositoryInterface {
        shared {
            let service = makeUserTravelService(tokenProvider: tokenProvider)
            return UserTravelRepository(service: service)
        }
    }
    
    private var placeRepository: PlaceRepositoryInterface {
        shared {
            let service = makePlaceService()
            let googlePlacesService = makeGooglePlacesService()
            return PlaceRepository(service: service, googlePlacesService: googlePlacesService)
        }
    }
    
    var weatherRepository: WeatherRepositoryInterface {
        shared {
            let service = makeWeatherService()
            return WeatherRepository(service: service)
        }
    }

    var homeUsecase: HomeUsecaseProtocol {
        shared {
            HomeUsecase(
                travelTemplateRepository: travelTemplateRepository,
                travelRepository: travelProgramRepository,
                userTravelRepository: userTravelRepository
            )
        }
    }
    
    var followDetailUsecase: FollowDetailUsecaseProtocol {
        shared {
            FollowDetailUsecase(
                travelTemplateRepository: travelTemplateRepository,
                userTravelRepository: userTravelRepository,
                placeRepository: placeRepository
            )
        }
    }
    
    var templateSearchUsecase: TemplatesSearchUsecaseProtocol {
        shared {
            TemplatesSearchUsecase(travelTemplateRepository: travelTemplateRepository)
        }
    }
    
    var myTravelUsecase: MyTravelUsecaseProtocol {
        shared {
            MyTravelUsecase(
                travelTemplateRepository: travelTemplateRepository,
                userTravelRepository: userTravelRepository
            )
        }
    }

    var authRepository: AuthRepositoryInterface {
        shared { makeAuthRepository() }
    }

    var tokenRepository: TokenRepositoryProtocol {
        shared { TokenRepositoryFactory.make() }
    }

    var tokenProvider: TokenProviding {
        shared { TokenRepositoryFactory.makeTokenProvider(with: tokenRepository) }
    }

    init() {
        super.init(dependency: EmptyComponent())
    }
}
