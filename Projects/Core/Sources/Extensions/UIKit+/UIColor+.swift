//
//  UIColor+.swift
//  27th-App-Team-1-iOSManifests
//
//  Created by 최안용 on 1/13/26.
//

import UIKit

public extension UIColor {
    /// Hex 문자열을UIColor로 변환합니다.
    /// - Parameters:
    ///   - hexCode: #RRGGBB 형식의 문자열
    ///   - alpha: 명시적인 투명도
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        let red   = (rgbValue & 0xFF0000) >> 16
        let green = (rgbValue & 0x00FF00) >> 8
        let blue  = (rgbValue & 0x0000FF)
        
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: alpha
        )
    }
}
