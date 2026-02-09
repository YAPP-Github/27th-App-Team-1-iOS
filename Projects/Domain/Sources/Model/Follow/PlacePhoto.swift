//
//  PlacePhoto.swift
//  Domain
//
//  Created by kimnahun on 2026-02-09.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Foundation

/// 장소 사진 정보
public struct PlacePhoto: Hashable {
    public let photoUri: String
    public let widthPx: Int
    public let heightPx: Int

    public init(photoUri: String, widthPx: Int, heightPx: Int) {
        self.photoUri = photoUri
        self.widthPx = widthPx
        self.heightPx = heightPx
    }
}
