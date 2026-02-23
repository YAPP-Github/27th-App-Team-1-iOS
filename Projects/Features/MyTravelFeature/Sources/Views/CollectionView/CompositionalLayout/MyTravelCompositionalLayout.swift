//
//  MyTravelCompositionalLayout.swift
//  MyTravelFeature
//
//  Created by 최안용 on 2/23/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import DSKit

extension MyTravelViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let sectionKind = self?.dataSource?.sectionIdentifier(for: sectionIndex) else {
                return self?.emptyLayout()
            }
            
            switch sectionKind {
            case .banner:
                return self?.createBannerSection()
                
            case .upcomingTrips(let isEmpty):
                if isEmpty {
                    return self?.createEmptyUpcomingSection()
                } else {
                    return self?.createUpcomingListSection()
                }
                
            case .recommendedTrip:
                return self?.createRecommendedTripSection()
            }
        }
    }
}

private extension MyTravelViewController {
    func createBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(80)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(MyTravelBannerCell.defaultWidth),
            heightDimension: .estimated(80)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = .init(
            top: 0,
            leading: 24.adjusted,
            bottom: 40.adjustedH,
            trailing: 24.adjusted
        )
        return section
    }
    
    func createEmptyUpcomingSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(EmptyUpcomingCell.defaultWidth),
            heightDimension: .absolute(EmptyUpcomingCell.defaultHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = .init(
            top: 20.adjustedH,
            leading: 24.adjusted,
            bottom: 40.adjustedH,
            trailing: 24.adjusted
        )
        section.boundarySupplementaryItems = [createHeaderLayout()]
        
        return section
    }
    
    func createUpcomingListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(UpcomingCell.defaultHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(UpcomingCell.defaultHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16.adjustedH
        
        section.contentInsets = .init(
            top: 16.adjustedH,
            leading: 24.adjusted,
            bottom: 40.adjustedH,
            trailing: 24.adjusted
        )
        section.boundarySupplementaryItems = [createHeaderLayout()]
        
        return section
    }
    
    func createRecommendedTripSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(RecommendInfoCell.defaultHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(RecommendInfoCell.defaultWidth),
            heightDimension: .estimated(RecommendInfoCell.defaultHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16.adjusted
        section.contentInsets = .init(
            top: 20.adjustedH,
            leading: 24.adjusted,
            bottom: 81.adjustedH,
            trailing: 24.adjusted
        )
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        
        section.boundarySupplementaryItems = [createHeaderLayout()]
        
        return section
    }
    
    func emptyLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let group = NSCollectionLayoutGroup(layoutSize: groupSize)
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }

    func createHeaderLayout() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(60)
        )
        
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )
    }
}
