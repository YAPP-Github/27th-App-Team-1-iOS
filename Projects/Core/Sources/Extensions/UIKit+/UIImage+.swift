//
//  UIImage+.swift
//  Core
//
//  Created by 최안용 on 1/26/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

public extension UIImage {
    /// 이미지를 가로·세로 동일한 크기의 정사이즈(Square)로 리사이징합니다.
        ///
        /// 주로 디자인 시스템에서 아이콘의 규격(16x16, 20x20, 24x24 등)을 맞추기 위해 사용합니다.
        /// 이 메서드는 원본의 비율을 무시하고 지정된 크기의 정사각형에 이미지를 채워 그리므로,
        /// **정사이즈 비율의 원본 이미지**에 사용하는 것을 권장합니다.
        ///
        /// - Parameter targetSize: 변경하고자 하는 정사각형의 한 변의 길이 (width = height)
        /// - Returns: 지정된 크기로 리사이징된 UIImage 객체
        ///
        /// ### Example
        /// ```swift
        /// let squareIcon = UIImage(named: "icon")?.resize(targetSize: 24)
        /// ```
    func resize(targetSize: CGFloat) -> UIImage {
        let size = CGSize(width: targetSize, height: targetSize)
        let render = UIGraphicsImageRenderer(size: size)
        return render.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
