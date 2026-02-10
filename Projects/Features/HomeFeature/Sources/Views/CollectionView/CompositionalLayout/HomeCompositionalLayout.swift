//
//  HomeCompositionalLayout.swift
//  HomeFeature
//
//  Created by 최안용 on 1/30/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import DSKit

extension HomeViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let sectionKind = HomeSectionKind(rawValue: sectionIndex) else {
                return self?.emptyLayout()
            }
            
            switch sectionKind {
            case .banner:
                return self?.createBannerSection()
            case .category:
                return self?.createCategorySection()
            case .popularTrip:
                return self?.createPopularTripSection()
            case .recommendedTrip:
                return self?.createRecommendedTripSection()
            }
        }
    }
}

private extension HomeViewController {
    func createBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(80)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(HomeBannerCell.defaultWidth),
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
            top: 21.adjustedH,
            leading: 24.adjusted,
            bottom: 40.adjustedH,
            trailing: 24.adjusted
        )
        return section
    }
    
    func createCategorySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(72),
            heightDimension: .absolute(CategoryChipCell.defaultHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(72),
            heightDimension: .absolute(CategoryChipCell.defaultHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 8.adjusted
        section.contentInsets = .init(
            top: 24.adjustedH,
            leading: 24.adjusted,
            bottom: 16.adjustedH,
            trailing: 24.adjusted
        )
        section.boundarySupplementaryItems = [createHeaderLayout()]
        return section
    }
    
    func createPopularTripSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(PopularInfoCell.defaultHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let itemSpacing: CGFloat = 12.adjustedH
        let totalGroupHeight = (PopularInfoCell.defaultHeight * 3) + (itemSpacing * 2)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(311.adjusted),
            heightDimension: .estimated(totalGroupHeight)
        )
        let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                repeatingSubitem: item,
                count: 3
            )
        group.interItemSpacing = .fixed(itemSpacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8.adjusted
        section.contentInsets = .init(
            top: 0,
            leading: 16.adjusted,
            bottom: 24.adjustedH,
            trailing: 24.adjusted
        )
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .absolute(327.adjusted),
            heightDimension: .estimated(80.adjustedH)
        )
        
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        footer.contentInsets = .init(top: 0, leading: 8.adjusted, bottom: 0, trailing: 0)
        section.boundarySupplementaryItems = [footer]

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
        section.contentInsets = .init(top: 24, leading: 24, bottom: 81.adjustedH, trailing: 24)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        
        section.boundarySupplementaryItems = [createHeaderLayout()]
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
}
