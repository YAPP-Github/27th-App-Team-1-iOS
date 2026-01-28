//
//  UIImage+.swift
//  Core
//
//  Created by 최안용 on 1/26/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

public extension UIImage {
    /// 이미지를 원본 비율을 유지하며 지정된 크기 내로 리사이징합니다.
    ///
    /// 가로와 세로 중 더 긴 변을 `targetSize`에 맞추고, 반대쪽 변은 원본 비율에 따라 자동으로 계산됩니다.
    /// 이미지 찌그러짐(Distortion) 없이 디자인 시스템의 아이콘 규격(16, 20, 24pt 등)을 맞출 때 사용합니다.
    ///
    /// - Parameter targetSize: 리사이징될 이미지의 최대 변 길이 (가로 또는 세로)
    /// - Returns: 원본 비율이 유지된 채 리사이징된 UIImage 객체
    ///
    /// ### 기능 설명
    /// - 원본 비율을 계산하여 이미지가 잘리거나 왜곡되지 않도록 합니다.
    /// - `UIGraphicsImageRenderer`를 사용하여 고해상도 디스플레이에서도 선명한 결과물을 생성합니다.
    ///
    /// ### Example
    /// ```swift
    /// // 가로가 긴 이미지(예: 100x50)를 20pt로 리사이징 시 -> 20x10 결과물 반환
    /// let scaledIcon = UIImage(named: "wide_icon")?.resize(targetSize: 20)
    /// ```
    func resize(targetSize: CGFloat) -> UIImage {
        guard self.size.width > 0, self.size.height > 0, targetSize > 0 else {
            return self
        }
        
        let widthRatio  = targetSize / self.size.width
        let heightRatio = targetSize / self.size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        let scaledWidth  = self.size.width * scaleFactor
        let scaledHeight = self.size.height * scaleFactor
        let targetSize = CGSize(width: scaledWidth, height: scaledHeight)
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
