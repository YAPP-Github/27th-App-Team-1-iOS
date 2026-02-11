//
//  UITableViewCell+.swift
//  Core
//
//  Created by 최안용 on 2/10/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

public extension UITableViewCell {
    static var cellIdentifier: String {
        return String(describing: self)
    }
}
