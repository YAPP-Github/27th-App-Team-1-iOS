//
//  UICollectionViewCell+.swift
//  Core
//
//  Created by 최안용 on 1/30/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

public extension UICollectionViewCell {
    static var cellIdentifier : String {
        return String(describing: self)
    }
}
