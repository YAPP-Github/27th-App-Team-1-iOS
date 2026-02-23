//
//  MyTravelRegistraion.swift
//  MyTravelFeature
//
//  Created by 최안용 on 2/23/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import DSKit

extension MyTravelViewController {
    func createEmptyUpcomingCellRegistration() -> UICollectionView.CellRegistration<EmptyUpcomingCell, MyTravelPresentationModel.Banner> {
        return UICollectionView.CellRegistration { [weak self] cell, _, _ in
            guard let self else { return }
            
            cell.buttonDidTap
                .bind(to: self.newTravelBtnTapped)
                .disposed(by: cell.disposeBag)
        }
    }
    
    func createBannerCellRegistration() -> UICollectionView.CellRegistration<MyTravelBannerCell, MyTravelPresentationModel.Banner> {
        return UICollectionView.CellRegistration { cell, indexPath, item in
            cell.configure(item)
        }
    }
    
    func createRecommedTripCellRegistration() -> UICollectionView.CellRegistration<RecommendInfoCell, MyTravelPresentationModel.RecommendedTrip> {
        return UICollectionView.CellRegistration { cell, indexPath, item in
            cell.configure(
                title: item.title,
                thumbnailUrl: item.thumbnailUrl,
                countryCode: item.country,
                creator: item.creator,
                city: item.city,
                schedule: item.schedule
            )
        }
    }
    
    func createUpcomingCell() -> UICollectionView.CellRegistration<UpcomingCell, MyTravelPresentationModel.Upcoming> {
        return UICollectionView.CellRegistration { cell, indexPath, item in
            cell.configure(title: item.title, date: item.duration, dDay: item.dDay, imageUrl: item.profileImage)
        }
    }
    
    func createHeaderRegistration() -> UICollectionView.SupplementaryRegistration<MyTravelHeaderView> {
        return UICollectionView.SupplementaryRegistration(
            elementKind: UICollectionView.elementKindSectionHeader) { [weak self] headerView, elementKind, indexPath in
                guard let self = self else { return }
                
                let sections = self.dataSource.snapshot().sectionIdentifiers
                guard indexPath.section < sections.count else { return }
                
                let sectionKind = sections[indexPath.section]
                headerView.configure(title: sectionKind.headerTitle)
            }
    }
}
