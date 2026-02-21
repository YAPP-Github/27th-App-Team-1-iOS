//
//  URLHelper.swift
//  Core
//
//  Created by 최안용 on 2/20/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

public struct URLHelper {
    public static func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}
