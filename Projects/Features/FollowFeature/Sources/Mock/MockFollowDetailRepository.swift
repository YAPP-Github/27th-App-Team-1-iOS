//
//  MockFollowDetailRepository.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-01-23.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import Foundation

final class MockFollowDetailRepository: FollowDetailRepositoryProtocol {

    func fetchTravelDetail(id: Int) async -> TravelDetail? {
        // 네트워크 지연 시뮬레이션
        try? await Task.sleep(nanoseconds: 100_000_000)

        return TravelDetail(
            travelId: "TRAVEL_001",
            country: "태국",
            city: "방콕",
            budgetPerPerson: 1_200_000,
            nights: 3,
            days: 4,
            youtube: YouTubeInfo(
                title: "방콕 풀코스, 동남아 안 가본 곽튜브와 함께 【방콕】",
                youtuber: "빠니보틀",
                thumbnail: "https://i.ytimg.com/vi/F2utz6L76D0/mqdefault.jpg",
                profileImage: nil,
                link: "https://www.youtube.com/watch?v=F2utz6L76D0",
                summary: "빠니보틀은 주말을 이용해 직장인들도 충분히 다녀올 수 있는 '금요일 퇴근 후 방콕 여행'의 가능성을 보여주며, 곽튜브와의 티격태격 케미를 통해 방콕의 매력을 소개합니다"
            )
        )
    }

    func fetchPlaces(travelId: Int, day: Int) async -> [TravelPlace] {
        // 네트워크 지연 시뮬레이션
        try? await Task.sleep(nanoseconds: 300_000_000)

        // 일차별로 다른 Mock 데이터 반환
        switch day {
        case 1:
            return [
                TravelPlace(
                    id: 1,
                    day: 1,
                    sequence: 1,
                    travelerTip: "인도 국제 공항에서 입국 심사가 오래 걸릴 수 있으니 여유를 가지세요.",
                    estimatedDuration: 60,
                    place: PlaceInfo(
                        googlePlaceId: "ChIJSc8jdZORQTURu6BMwxrKbGg",
                        latitude: 35.6585805,
                        longitude: 139.7454329,
                        name: "인도 국제 공항",
                        regularOpeningHours: "00:00~24:00",
                        category: .transportation
                    )
                ),
                TravelPlace(
                    id: 2,
                    day: 1,
                    sequence: 2,
                    travelerTip: "바라나시 시장 투어는 현지 가이드와 함께 하는 것이 좋습니다.",
                    estimatedDuration: 90,
                    place: PlaceInfo(
                        googlePlaceId: "ChIJN1t_tDeuEmsRUsoyG83frY4",
                        latitude: 35.6592606,
                        longitude: 139.7002586,
                        name: "바라나시 시장 투어",
                        regularOpeningHours: "06:00~18:00",
                        category: .tourism
                    )
                ),
                TravelPlace(
                    id: 3,
                    day: 1,
                    sequence: 3,
                    travelerTip: "현지인들이 추천하는 맛집입니다. 탄두리 치킨이 맛있어요.",
                    estimatedDuration: 60,
                    place: PlaceInfo(
                        googlePlaceId: "ChIJabc123",
                        latitude: 35.6600000,
                        longitude: 139.7100000,
                        name: "짱짱 탄두리 치킨",
                        regularOpeningHours: "11:00~22:00",
                        category: .restaurant
                    )
                ),
                TravelPlace(
                    id: 4,
                    day: 1,
                    sequence: 4,
                    travelerTip: "현지 커피를 맛볼 수 있는 카페입니다.",
                    estimatedDuration: 30,
                    place: PlaceInfo(
                        googlePlaceId: "ChIJdef456",
                        latitude: 35.6610000,
                        longitude: 139.7150000,
                        name: "맛있다 카페",
                        regularOpeningHours: "08:00~20:00",
                        category: .cafe
                    )
                ),
                TravelPlace(
                    id: 5,
                    day: 1,
                    sequence: 5,
                    travelerTip: "깔끔한 숙소입니다. 조식이 포함되어 있어요.",
                    estimatedDuration: 480,
                    place: PlaceInfo(
                        googlePlaceId: "ChIJghi789",
                        latitude: 35.6620000,
                        longitude: 139.7200000,
                        name: "쿨쿨호텔",
                        regularOpeningHours: nil,
                        category: .accommodation
                    )
                )
            ]
        case 2:
            return [
                TravelPlace(
                    id: 6,
                    day: 2,
                    sequence: 1,
                    travelerTip: "아침 일찍 가면 사람이 적어서 좋습니다.",
                    estimatedDuration: 120,
                    place: PlaceInfo(
                        googlePlaceId: "ChIJaaa111",
                        latitude: 35.6700000,
                        longitude: 139.7300000,
                        name: "타지마할",
                        regularOpeningHours: "06:00~18:00",
                        category: .tourism
                    )
                ),
                TravelPlace(
                    id: 7,
                    day: 2,
                    sequence: 2,
                    travelerTip: "현지 전통 음식을 맛볼 수 있습니다.",
                    estimatedDuration: 60,
                    place: PlaceInfo(
                        googlePlaceId: "ChIJbbb222",
                        latitude: 35.6710000,
                        longitude: 139.7310000,
                        name: "전통 음식점",
                        regularOpeningHours: "10:00~21:00",
                        category: .restaurant
                    )
                )
            ]
        case 3:
            return [
                TravelPlace(
                    id: 8,
                    day: 3,
                    sequence: 1,
                    travelerTip: "쇼핑하기 좋은 곳입니다.",
                    estimatedDuration: 180,
                    place: PlaceInfo(
                        googlePlaceId: "ChIJccc333",
                        latitude: 35.6800000,
                        longitude: 139.7400000,
                        name: "현지 시장",
                        regularOpeningHours: "09:00~20:00",
                        category: .tourism
                    )
                )
            ]
        default:
            return []
        }
    }
}
