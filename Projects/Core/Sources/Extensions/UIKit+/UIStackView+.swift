//
//  UIStackView+.swift
//  Core
//
//  Created by 최안용 on 1/23/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

public extension UIStackView {
    /// 여러 개의 UIView를 한 번에 addArrangedSubview 해주는 함수
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
}
