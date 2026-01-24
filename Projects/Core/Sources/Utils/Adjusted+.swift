//
//  Adjusted+.swift
//  Core
//
//  Created by 최안용 on 1/24/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

/**
 - Description:
 NDGL 디자인은 iphone 13 mini 기준으로 디자인 됩니다. (375 * 812)
 스크린 너비 375 를 기준으로 디자인이 나왔을 때 현재 기기의 스크린 사이즈에 비례하는 수치를 Return한다.
 스크린 높이 812 를 기준으로 디자인이 나왔을 때 현재 기기의 스크린 사이즈에 비례하는 수치를 Return한다.
 
 - Note:
 기기별 대응에 사용하면 된다.
 ex) (size: 20.adjusted)
 ex) (size: 60.adjustedH)
 */

public extension CGFloat {
    var adjusted: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.width / 375
        return self * ratio
    }
    
    var adjustedH: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.height / 812
        return self * ratio
    }
}

public extension Double {
    var adjusted: Double {
        let ratio: Double = Double(UIScreen.main.bounds.width / 375)
        return self * ratio
    }
    
    var adjustedH: Double {
        let ratio: Double = Double(UIScreen.main.bounds.height / 812)
        return self * ratio
    }
}

public extension Int {
    var adjusted: CGFloat {
        CGFloat(self).adjusted
    }
    
    var adjustedH: CGFloat {
        CGFloat(self).adjustedH
    }
}
