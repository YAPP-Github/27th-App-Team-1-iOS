//
//  UILabel+.swift
//  DSKit
//
//  Created by 최안용 on 1/21/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

public extension UILabel {
    /// NDGL 디자인 시스템 가이드에 맞게 초기 UILabel의 텍스트 스타일을 설정합니다.
    ///
    /// 이 메서드는 `UIFont.NDGL`에 정의된 폰트, 행간(LineHeight), 자간(Kern)을 자동으로 적용하며,
    /// `attributedText`를 사용하여 시스템 폰트보다 정교한 타이포그래피를 구현합니다.
    ///
    /// - Parameters:
    ///   - style: 적용할 NDGL 타이포그래피 스타일 (예: `.titleLB`, `.bodyLM`)
    ///   - text: 표시할 문자열 내용
    ///   - color: 적용할 텍스트 색상 (예: `.NDGL.Text.primary`)
    ///   - alignment: 텍스트 정렬 방식 (기본값은 `.left`)
    ///
    /// - Note:
    ///   - 이 메서드를 사용하면 `attributedText`가 새로 생성되므로 기존 속성은 덮어씌워집니다.
    ///   - `""`와 같이 빈 텍스트로 초기화 시 폰트 적용이 되지 않으니 주의하세요.
    ///   - 빈 라베을 생성한 뒤 나중에 text를 설정한다면 해당 함수를 사용하세요
    ///   - 텍스트 내용만 변경 시에는 `updateText(_:)`를 사용하세요.
    ///   - 색상만 변경 시에는 `changeColor(_:)`를 사용하세요.
    func setText(
        _ style: UIFont.NDGL,
        text: String,
        color: UIColor,
        alignment: NSTextAlignment = .left
    ) {
        var attributes = style.attributes
        
        if let paragraphStyle = attributes[.paragraphStyle] as? NSMutableParagraphStyle {
            paragraphStyle.alignment = alignment
            paragraphStyle.lineBreakMode = .byTruncatingTail
            attributes[.paragraphStyle] = paragraphStyle
        }
        
        attributes[.foregroundColor] = color
        
        self.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
}
