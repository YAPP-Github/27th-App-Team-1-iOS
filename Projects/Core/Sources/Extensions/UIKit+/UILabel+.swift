//
//  UILabel+.swift.swift
//  Core
//
//  Created by 최안용 on 1/21/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

public extension UILabel {
    /// 기존에 적용된 디자인 시스템 스타일(폰트, 행간, 자간 등)을 유지하면서 텍스트 내용만 교체합니다.
    /// - Parameter text: 새로 표기할 문자열
    func updateText(_ text: String) {
        guard !text.isEmpty else {
            self.attributedText = nil
            self.text = ""
            return
        }
        
        guard let attributedText = self.attributedText, attributedText.length > 0 else {
            self.text = text
            return
        }
        
        let mutableAtbString = NSMutableAttributedString(string: text)
        let attributes = attributedText.attributes(at: 0, effectiveRange: nil)
        mutableAtbString.addAttributes(attributes, range: NSRange(location: 0, length: text.count))
        
        self.attributedText = mutableAtbString
    }
    
    /// 기존 텍스트와 스타일(폰트, 행간 등)은 유지하고 글자 색상만 변경합니다.
    /// - Parameter color: 변경할 UIColor
    func changeColor(_ color: UIColor) {
        guard let attributedText = self.attributedText else {
            self.textColor = color
            return
        }
        
        let mutableAtbString = NSMutableAttributedString(attributedString: attributedText)
        let range = NSRange(location: 0, length: mutableAtbString.length)
        
        mutableAtbString.addAttribute(.foregroundColor, value: color, range: range)
        
        self.attributedText = mutableAtbString
    }
}
