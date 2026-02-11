//
//  PopularTravelCompositionalLayout.swift
//  PopularTravelFeature
//
//  Created by 최안용 on 2/12/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import DSKit

extension PopularTravelViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let sectionKind = PopularTravelSectionKind(rawValue: sectionIndex) else {
                return self?.emptyLayout()
            }
            
            switch sectionKind {
            case .category:
                return self?.createCategorySection()
            case .popularTrip:
                return self?.createPopularTripSection()
            }
        }
    }
}

private extension PopularTravelViewController {
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
            top: 20.adjustedH,
            leading: 24.adjusted,
            bottom: 32.adjustedH,
            trailing: 24.adjusted
        )
        return section
    }
    
    func createPopularTripSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(PopularInfoCell.defaultHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(PopularInfoCell.defaultHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16.adjustedH
        
        section.contentInsets = .init(
            top: 0,
            leading: 24.adjusted,
            bottom: 12.adjustedH,
            trailing: 24.adjusted
        )
        section.orthogonalScrollingBehavior = .none

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
}
