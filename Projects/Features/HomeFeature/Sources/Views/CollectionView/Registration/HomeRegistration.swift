//
//  HomeRegistration.swift
//  HomeFeature
//
//  Created by 최안용 on 2/6/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import DSKit

extension HomeViewController {
    func createBannerCellRegistration() -> UICollectionView.CellRegistration<HomeBannerCell, HomePresentationModel.Banner> {
        return UICollectionView.CellRegistration { cell, indexPath, item in
            cell.configure(item)
        }
    }
    
    func createCategoryCellRegistration() -> UICollectionView.CellRegistration<CategoryChipCell, (HomePresentationModel.Category, Bool)> {
        return UICollectionView.CellRegistration { cell, indexPath, item in
            let (chip, isSelected) = item
            
            let chipType: ChipIconType = {
                switch chip.viedoType {
                case .tv: ChipIconType.tv
                case .youtube: ChipIconType.youtube
                case .none: ChipIconType.none
                }
            }()
            
            cell.configure(chipType, chip.creator, isSelected)
        }
    }
    
    func createPopularTripCellRegistration() -> UICollectionView.CellRegistration<PopularInfoCell, HomePresentationModel.PopularTrip> {
        return UICollectionView.CellRegistration { cell, indexPath, item in
            cell.configure(
                thumbnailUrl: item.thumbnailUrl,
                city: item.city,
                title: item.title,
                nation: item.country,
                schedule: item.schedule
            )
        }
    }
    
    func createRecommedTripCellRegistration() -> UICollectionView.CellRegistration<RecommendInfoCell, HomePresentationModel.RecommendedTrip> {
        return UICollectionView.CellRegistration { cell, indexPath, item in
            cell.configure(item)
        }
    }
    
    func createHeaderRegistration() -> UICollectionView.SupplementaryRegistration<HomeHeaderView> {
        return UICollectionView.SupplementaryRegistration<HomeHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { headerView,elementKind,indexPath in
            guard let sectionKind = HomeSectionKind(rawValue: indexPath.section) else { return }
            
            headerView.configure(title: sectionKind.headerTitle)
        }
    }
    
    func createPopularFooterRegistration() -> UICollectionView.SupplementaryRegistration<HomeFooterButtonView> {
        return UICollectionView.SupplementaryRegistration<HomeFooterButtonView>(elementKind: UICollectionView.elementKindSectionFooter) { [weak self] footerView,elementKind,indexPath in
            guard let self = self else { return }
            
            footerView.plusBtnTapped
                .bind(to: self.moreButtonTapped)
                .disposed(by: footerView.disposeBag)
        }
    }
}
