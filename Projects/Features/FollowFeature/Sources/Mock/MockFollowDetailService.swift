//
//  MockFollowDetailService.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-01-23.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import Foundation

final class MockFollowDetailService: FollowServiceProtocol {

    func fetchTravelDetail(id: Int) async -> Result<TravelDetail, FollowError> {
        // 네트워크 지연 시뮬레이션
        try? await Task.sleep(nanoseconds: 100_000_000)

        return .success(TravelDetail(
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
                summary: "빠니보틀은 주말을 이용해 직장인들도 충분히 다녀올 수 있는 '금요일 퇴근 후 방콕 여행'의 가능성을 보여주며"
            )
        ))
    }

    func fetchPlaces(travelId: Int, day: Int) async -> Result<[TravelPlace], FollowError> {
        // 네트워크 지연 시뮬레이션
        try? await Task.sleep(nanoseconds: 300_000_000)

        // 일차별로 다른 Mock 데이터 반환
        switch day {
        case 1:
            return .success([
                TravelPlace(
                    id: 1,
                    day: 1,
                    sequence: 1,
                    distanceKm: nil,
                    transportation: [],
                    youtubeTips: ["인도 국제 공항에서 입국 심사가 오래 걸릴 수 있으니 여유를 가지세요."],
                    planB: [],
                    estimatedDuration: 60,
                    place: PlaceInfo(
                        googlePlaceId: "ChIJSc8jdZORQTURu6BMwxrKbGg",
                        thumbnail: "https://example.com/airport.jpg",
                        latitude: 35.6585805,
                        longitude: 139.7454329,
                        name: "인도 국제 공항",
                        regularOpeningHours: "00:00~24:00",
                        googleMapsUri: "https://maps.google.com/?cid=123456"
                    )
                ),
                TravelPlace(
                    id: 2,
                    day: 1,
                    sequence: 2,
                    distanceKm: 5.2,
                    transportation: [Transportation(mode: "TAXI", timeMin: 15)],
                    youtubeTips: ["바라나시 시장 투어는 현지 가이드와 함께 하는 것이 좋습니다."],
                    planB: [],
                    estimatedDuration: 90,
                    place: PlaceInfo(
                        googlePlaceId: "ChIJN1t_tDeuEmsRUsoyG83frY4",
                        thumbnail: "https://example.com/market.jpg",
                        latitude: 35.6592606,
                        longitude: 139.7002586,
                        name: "바라나시 시장 투어",
                        regularOpeningHours: "06:00~18:00",
                        googleMapsUri: "https://maps.google.com/?cid=234567"
                    )
                ),
                TravelPlace(
                    id: 3,
                    day: 1,
                    sequence: 3,
                    distanceKm: 1.5,
                    transportation: [Transportation(mode: "WALK", timeMin: 10)],
                    youtubeTips: ["현지인들이 추천하는 맛집입니다. 탄두리 치킨이 맛있어요."],
                    planB: [],
                    estimatedDuration: 60,
                    place: PlaceInfo(
                        googlePlaceId: "ChIJabc123",
                        thumbnail: "https://example.com/chicken.jpg",
                        latitude: 35.6600000,
                        longitude: 139.7100000,
                        name: "짱짱 탄두리 치킨",
                        regularOpeningHours: "11:00~22:00",
                        googleMapsUri: "https://maps.google.com/?cid=345678"
                    )
                ),
                TravelPlace(
                    id: 4,
                    day: 1,
                    sequence: 4,
                    distanceKm: 0.8,
                    transportation: [Transportation(mode: "WALK", timeMin: 5)],
                    youtubeTips: ["현지 커피를 맛볼 수 있는 카페입니다."],
                    planB: [],
                    estimatedDuration: 30,
                    place: PlaceInfo(
                        googlePlaceId: "ChIJdef456",
                        thumbnail: "https://example.com/cafe.jpg",
                        latitude: 35.6610000,
                        longitude: 139.7150000,
                        name: "맛있다 카페",
                        regularOpeningHours: "08:00~20:00",
                        googleMapsUri: "https://maps.google.com/?cid=456789"
                    )
                ),
                TravelPlace(
                    id: 5,
                    day: 1,
                    sequence: 5,
                    distanceKm: 2.0,
                    transportation: [Transportation(mode: "TAXI", timeMin: 10)],
                    youtubeTips: ["깔끔한 숙소입니다. 조식이 포함되어 있어요."],
                    planB: [],
                    estimatedDuration: 480,
                    place: PlaceInfo(
                        googlePlaceId: "ChIJghi789",
                        thumbnail: "https://example.com/hotel.jpg",
                        latitude: 35.6620000,
                        longitude: 139.7200000,
                        name: "쿨쿨호텔",
                        regularOpeningHours: nil,
                        googleMapsUri: "https://maps.google.com/?cid=567890"
                    )
                )
            ])
        case 2:
            return .success([
                TravelPlace(
                    id: 6,
                    day: 2,
                    sequence: 1,
                    distanceKm: nil,
                    transportation: [],
                    youtubeTips: ["아침 일찍 가면 사람이 적어서 좋습니다."],
                    planB: [],
                    estimatedDuration: 120,
                    place: PlaceInfo(
                        googlePlaceId: "ChIJaaa111",
                        thumbnail: "https://example.com/tajmahal.jpg",
                        latitude: 35.6700000,
                        longitude: 139.7300000,
                        name: "타지마할",
                        regularOpeningHours: "06:00~18:00",
                        googleMapsUri: "https://maps.google.com/?cid=678901"
                    )
                ),
                TravelPlace(
                    id: 7,
                    day: 2,
                    sequence: 2,
                    distanceKm: 3.0,
                    transportation: [Transportation(mode: "BUS", timeMin: 20)],
                    youtubeTips: ["현지 전통 음식을 맛볼 수 있습니다."],
                    planB: [],
                    estimatedDuration: 60,
                    place: PlaceInfo(
                        googlePlaceId: "ChIJbbb222",
                        thumbnail: "https://example.com/restaurant.jpg",
                        latitude: 35.6710000,
                        longitude: 139.7310000,
                        name: "전통 음식점",
                        regularOpeningHours: "10:00~21:00",
                        googleMapsUri: "https://maps.google.com/?cid=789012"
                    )
                )
            ])
        case 3:
            return .success([
                TravelPlace(
                    id: 8,
                    day: 3,
                    sequence: 1,
                    distanceKm: nil,
                    transportation: [],
                    youtubeTips: ["쇼핑하기 좋은 곳입니다."],
                    planB: [],
                    estimatedDuration: 180,
                    place: PlaceInfo(
                        googlePlaceId: "ChIJccc333",
                        thumbnail: "https://example.com/market2.jpg",
                        latitude: 35.6800000,
                        longitude: 139.7400000,
                        name: "현지 시장",
                        regularOpeningHours: "09:00~20:00",
                        googleMapsUri: "https://maps.google.com/?cid=890123"
                    )
                )
            ])
        default:
            return .success([])
        }
    }
}
