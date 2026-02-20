//
//  SearchResultCompositionalLayout.swift
//  SearchFeature
//
//  Created by 최안용 on 2/18/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import DSKit

extension SearchResultViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let sectionKind = SearchResultSectionKind(rawValue: sectionIndex) else {
                return self?.emptyLayout()
            }
            
            switch sectionKind {
            case .resultTrip:
                return self?.createPopularTripSection()
            }
        }
    }
}

private extension SearchResultViewController {
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
            top: 16.adjustedH,
            leading: 24.adjusted,
            bottom: 12.adjustedH,
            trailing: 24.adjusted
        )
        section.orthogonalScrollingBehavior = .none

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .estimated(43.adjusted),
            heightDimension: .absolute(30.adjustedH)
        )

        let header =  NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )
        
        section.boundarySupplementaryItems = [header]

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
