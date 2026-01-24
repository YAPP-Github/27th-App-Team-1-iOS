//
//  UIView+.swift
//  Core
//
//  Created by 최안용 on 1/23/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

public extension UIView {
    /// 여러 개의 UIView를 한 번에 addSubview 해주는 함수
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
}
