//
//  MockTravelRepository.swift
//  HomeFeature
//
//  Created by kimnahun on 2026-01-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain
import Foundation

final class MockTravelRepository: TravelRepositoryProtocol {

    func fetchMyTrips() async -> [MyTrip] {
        try? await Task.sleep(nanoseconds: 300_000_000)

        return [
            MyTrip(
                id: 1,
                title: "도쿄 여행",
                destination: "일본 도쿄",
                startDate: Date(),
                endDate: Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date(),
                thumbnailURL: nil
            ),
            MyTrip(
                id: 2,
                title: "파리 여행",
                destination: "프랑스 파리",
                startDate: Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date(),
                endDate: Calendar.current.date(byAdding: .day, value: 37, to: Date()) ?? Date(),
                thumbnailURL: nil
            )
        ]
    }

    func fetchPopularTrips(category: TripCategory) async -> [PopularTrip] {
        try? await Task.sleep(nanoseconds: 300_000_000)

        let allTrips: [PopularTrip] = [
            PopularTrip(
                id: 1,
                title: "베트남 다낭 3박 4일",
                authorName: "여행작가 김",
                destination: "베트남 다낭",
                duration: "3박 4일",
                thumbnailURL: nil,
                category: .vietnam
            ),
            PopularTrip(
                id: 2,
                title: "파리 로맨틱 여행",
                authorName: "유럽전문가",
                destination: "프랑스 파리",
                duration: "5박 6일",
                thumbnailURL: nil,
                category: .europe
            ),
            PopularTrip(
                id: 3,
                title: "홍콩 먹방 투어",
                authorName: "맛집헌터",
                destination: "홍콩",
                duration: "2박 3일",
                thumbnailURL: nil,
                category: .hongkong
            ),
            PopularTrip(
                id: 4,
                title: "싱가포르 가족여행",
                authorName: "가족여행전문",
                destination: "싱가포르",
                duration: "4박 5일",
                thumbnailURL: nil,
                category: .singapore
            ),
            PopularTrip(
                id: 5,
                title: "오사카 맛집 투어",
                authorName: "일본통",
                destination: "일본 오사카",
                duration: "3박 4일",
                thumbnailURL: nil,
                category: .japan
            )
        ]

        if category == .all {
            return allTrips
        } else {
            return allTrips.filter { $0.category == category }
        }
    }

    func fetchRecommendations() async -> [Recommendation] {
        try? await Task.sleep(nanoseconds: 300_000_000)

        return [
            Recommendation(
                id: 1,
                title: "인플루언서 A의 발리 여행기",
                authorName: "인플루언서 A",
                destination: "인도네시아 발리",
                duration: "7박 8일",
                thumbnailURL: nil
            ),
            Recommendation(
                id: 2,
                title: "작가 B의 유럽 배낭여행",
                authorName: "여행작가 B",
                destination: "유럽 5개국",
                duration: "14박 15일",
                thumbnailURL: nil
            ),
            Recommendation(
                id: 3,
                title: "셰프 C의 태국 미식 여행",
                authorName: "셰프 C",
                destination: "태국 방콕",
                duration: "4박 5일",
                thumbnailURL: nil
            )
        ]
    }
}
