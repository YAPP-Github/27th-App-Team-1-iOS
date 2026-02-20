//
//  SearchResultRegistration.swift
//  SearchFeature
//
//  Created by 최안용 on 2/18/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import DSKit

extension SearchResultViewController {
    func createResultTripCellRegistration()
    -> UICollectionView.CellRegistration<PopularInfoCell, SearchResultPresentationModel.ResultTrip> {
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
    
    func createHeaderRegistration(
        dataSource: UICollectionViewDiffableDataSource<SearchResultSectionKind, SearchResultItem>
    ) -> UICollectionView.SupplementaryRegistration<SearchResultHeaderView> {
        return UICollectionView.SupplementaryRegistration<SearchResultHeaderView>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { [weak dataSource] headerView, elementKind, indexPath in
            guard let dataSource else { return }
            
            let snapshot = dataSource.snapshot()
            let itemCount = snapshot.numberOfItems(inSection: .resultTrip)
            
            headerView.configure(count: itemCount)
        }
    }
}
