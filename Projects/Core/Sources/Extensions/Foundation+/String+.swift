//
//  String+.swift
//  Core
//
//  Created by 최안용 on 1/31/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

public extension String {
    func toFlag() -> String {
        guard self.count == 2 else { return "🏳️" }
        
        let base: UInt32 = 127397
        var flagString = ""
        
        for uni in self.uppercased().unicodeScalars {
            if let scalar = UnicodeScalar(base + uni.value) {
                flagString.append(String(scalar))
            } else {
                return "🏳️"
            }
        }
        return flagString
    }
    
    func toKoreanCountryName() -> String {
        guard self.count == 2 else { return "알 수 없음" }
        
        let locale = Locale(identifier: "ko_KR")
        return locale.localizedString(forRegionCode: self) ?? "알 수 없음"
    }
}
