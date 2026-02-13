//
//  PopularTravelRegistration.swift
//  PopularTravelFeature
//
//  Created by 최안용 on 2/12/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import DSKit

extension PopularTravelViewController {
    func createCategoryCellRegistration() -> UICollectionView.CellRegistration<CategoryChipCell, (PopularTravelPresentationModel.Category, Bool)> {
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
    
    func createPopularTripCellRegistration() -> UICollectionView.CellRegistration<PopularInfoCell, PopularTravelPresentationModel.PopularTrip> {
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
}
