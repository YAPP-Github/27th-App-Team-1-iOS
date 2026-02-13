//
//  UICollectionReusableView+.swift
//  Core
//
//  Created by 최안용 on 2/3/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

public extension UICollectionReusableView {
    static var reusableViewIdentifier : String {
        return String(describing: self)
    }
}
