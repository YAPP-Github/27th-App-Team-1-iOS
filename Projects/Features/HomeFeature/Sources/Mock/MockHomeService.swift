//
//  MockHomeService.swift
//  HomeFeature
//
//  Created by kimnahun on 2026-01-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import Foundation

final class MockHomeService: HomeServiceProtocol {

    private let mockImageURLs = [
        "https://picsum.photos/400/300?random=1",
        "https://picsum.photos/400/300?random=2",
        "https://picsum.photos/400/300?random=3",
        "https://picsum.photos/400/300?random=4",
        "https://picsum.photos/400/300?random=5",
        "https://picsum.photos/400/300?random=6",
        "https://picsum.photos/400/300?random=7",
        "https://picsum.photos/400/300?random=8",
        "https://picsum.photos/400/300?random=9",
        "https://picsum.photos/400/300?random=10",
        "https://picsum.photos/400/300?random=11",
        "https://picsum.photos/400/300?random=12",
        "https://picsum.photos/400/300?random=13",
        "https://picsum.photos/400/300?random=14",
        "https://picsum.photos/400/300?random=15"
    ]

    func fetchMyTrips() async -> Result<[MyTrip], HomeError> {
        try? await Task.sleep(nanoseconds: 300_000_000)

        return .success([
            MyTrip(
                id: 1,
                title: "도쿄 여행",
                destination: "일본 도쿄",
                startDate: Date(),
                endDate: Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date(),
                thumbnailURL: mockImageURLs[0]
            ),
            MyTrip(
                id: 2,
                title: "파리 여행",
                destination: "프랑스 파리",
                startDate: Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date(),
                endDate: Calendar.current.date(byAdding: .day, value: 37, to: Date()) ?? Date(),
                thumbnailURL: mockImageURLs[1]
            )
        ])
    }

    func fetchPopularTrips(category: TripCategory) async -> Result<[PopularTrip], HomeError> {
        let allTripsResult = await fetchAllPopularTrips()
        guard case .success(let allTrips) = allTripsResult else {
            return .success([])
        }

        if category == .all {
            return .success(allTrips.values.flatMap { $0 })
        } else {
            return .success(allTrips[category] ?? [])
        }
    }

    func fetchAllPopularTrips() async -> Result<[TripCategory: [PopularTrip]], HomeError> {
        try? await Task.sleep(nanoseconds: 300_000_000)

        return .success([
            .all: [
                PopularTrip(id: 100, title: "곽준빈의 신혼여행", authorName: "곽튜브", destination: "파리", duration: "2박3일", thumbnailURL: mockImageURLs[0], category: .all),
                PopularTrip(id: 101, title: "6박7일 스위스 여행", authorName: "찰스엔터", destination: "스위스", duration: "5박6일", thumbnailURL: mockImageURLs[1], category: .all),
                PopularTrip(id: 102, title: "충격적인 북유럽 물가", authorName: "곽튜브", destination: "북유럽", duration: "6박7일", thumbnailURL: mockImageURLs[2], category: .all)
            ],
            .vietnam: [
                PopularTrip(id: 1, title: "다낭 힐링 여행", authorName: "빠니보틀", destination: "다낭", duration: "3박4일", thumbnailURL: mockImageURLs[3], category: .vietnam),
                PopularTrip(id: 2, title: "호치민 먹방 투어", authorName: "먹방작가", destination: "호치민", duration: "4박5일", thumbnailURL: mockImageURLs[4], category: .vietnam),
                PopularTrip(id: 3, title: "하노이 역사 탐방", authorName: "역사탐방가", destination: "하노이", duration: "3박4일", thumbnailURL: mockImageURLs[5], category: .vietnam)
            ],
            .europe: [
                PopularTrip(id: 4, title: "파리 로맨틱 여행", authorName: "곽튜브", destination: "파리", duration: "5박6일", thumbnailURL: mockImageURLs[6], category: .europe),
                PopularTrip(id: 5, title: "스위스 알프스 투어", authorName: "콩콩팡팡", destination: "스위스", duration: "6박7일", thumbnailURL: mockImageURLs[7], category: .europe),
                PopularTrip(id: 6, title: "이탈리아 미식 여행", authorName: "신서유기", destination: "이탈리아", duration: "7박8일", thumbnailURL: mockImageURLs[8], category: .europe)
            ],
            .hongkong: [
                PopularTrip(id: 7, title: "홍콩 야경 투어", authorName: "여행작가", destination: "홍콩", duration: "2박3일", thumbnailURL: mockImageURLs[9], category: .hongkong),
                PopularTrip(id: 8, title: "마카오 카지노 여행", authorName: "럭셔리트래블", destination: "마카오", duration: "2박3일", thumbnailURL: mockImageURLs[10], category: .hongkong),
                PopularTrip(id: 9, title: "홍콩 맛집 탐방", authorName: "맛집헌터", destination: "홍콩", duration: "3박4일", thumbnailURL: mockImageURLs[11], category: .hongkong)
            ],
            .singapore: [
                PopularTrip(id: 10, title: "싱가포르 가족여행", authorName: "가족여행전문", destination: "싱가포르", duration: "4박5일", thumbnailURL: mockImageURLs[12], category: .singapore),
                PopularTrip(id: 11, title: "마리나베이 야경", authorName: "야경전문가", destination: "싱가포르", duration: "3박4일", thumbnailURL: mockImageURLs[13], category: .singapore),
                PopularTrip(id: 12, title: "센토사 리조트 힐링", authorName: "힐링여행", destination: "싱가포르", duration: "4박5일", thumbnailURL: mockImageURLs[14], category: .singapore)
            ],
            .japan: [
                PopularTrip(id: 13, title: "오사카 맛집 투어", authorName: "일본통", destination: "오사카", duration: "3박4일", thumbnailURL: mockImageURLs[0], category: .japan),
                PopularTrip(id: 14, title: "도쿄 쇼핑 여행", authorName: "쇼핑퀸", destination: "도쿄", duration: "4박5일", thumbnailURL: mockImageURLs[1], category: .japan),
                PopularTrip(id: 15, title: "교토 전통 문화", authorName: "문화탐방", destination: "교토", duration: "3박4일", thumbnailURL: mockImageURLs[2], category: .japan)
            ]
        ])
    }

    func fetchRecommendations() async -> Result<[Recommendation], HomeError> {
        try? await Task.sleep(nanoseconds: 300_000_000)

        return .success([
            Recommendation(
                id: 1,
                title: "인플루언서 A의 발리 여행기",
                authorName: "인플루언서 A",
                destination: "인도네시아 발리",
                duration: "7박 8일",
                thumbnailURL: mockImageURLs[0]
            ),
            Recommendation(
                id: 2,
                title: "작가 B의 유럽 배낭여행",
                authorName: "여행작가 B",
                destination: "유럽 5개국",
                duration: "14박 15일",
                thumbnailURL: mockImageURLs[1]
            ),
            Recommendation(
                id: 3,
                title: "셰프 C의 태국 미식 여행",
                authorName: "셰프 C",
                destination: "태국 방콕",
                duration: "4박 5일",
                thumbnailURL: mockImageURLs[2]
            )
        ])
    }
}
