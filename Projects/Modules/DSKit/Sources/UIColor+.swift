//
//  UIColor+.swift
//  DSKit
//
//  Created by 최안용 on 1/21/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//
// swiftlint:disable nesting

import UIKit

extension UIColor {
    public enum NDGL {
        public enum Text {
            public static let primary = DSKitAsset.gray900.color
            public static let secondary = DSKitAsset.gray700.color
            public static let tertiary = DSKitAsset.gray500.color
            public static  let danger = DSKitAsset.red600.color
            public static let disabled = DSKitAsset.gray400.color
                
            public enum Interactive {
                public static let primary = DSKitAsset.primary500.color
                public static let primaryHovered = DSKitAsset.primary600.color
                public static let primaryPressed = DSKitAsset.primary700.color
                public static let secondary = DSKitAsset.gray600.color
                public static let secondaryHovered = DSKitAsset.gray700.color
                public static let secondaryPressed = DSKitAsset.gray800.color
                public static let inverse = DSKitAsset.baseWhite.color
            }
        }
        
        public enum Bg {
            public static let primary = DSKitAsset.baseWhite.color
            public static let disabled = DSKitAsset.gray300.color
            
            public enum Interactive {
                public static let primary = DSKitAsset.primary500.color
                public static let primaryHovered = DSKitAsset.primary600.color
                public static let primaryPressed = DSKitAsset.primary700.color
                public static let secondary = DSKitAsset.gray500.color
                public static let secondaryHovered = DSKitAsset.gray600.color
                public static let secondaryPressed = DSKitAsset.gray700.color
                public static let selected = DSKitAsset.primary50.color
                public static let selectedHovered = DSKitAsset.primary100.color
                public static let selectedPressed = DSKitAsset.primary200.color
                public static let subtle = DSKitAsset.red50.color
                public static let subtleHovered = DSKitAsset.red100.color
                public static let subtlePressed = DSKitAsset.red200.color
                public static let subtle02 = DSKitAsset.gray50.color
                public static let subtle02Hovered = DSKitAsset.gray100.color
                public static let subtle02Pressed = DSKitAsset.gray200.color
            }
        }
        
        public enum Icon {
            public static let primary = DSKitAsset.gray900.color
            public static let secondary = DSKitAsset.gray700.color
            public static let teriary = DSKitAsset.gray500.color
            public static let danger = DSKitAsset.red700.color
            public static let disabled = DSKitAsset.gray400.color
            
            public enum Interactive {
                public static let primary = DSKitAsset.primary500.color
                public static let primaryHovered = DSKitAsset.primary600.color
                public static let primaryPressed = DSKitAsset.primary700.color
                public static let secondary = DSKitAsset.gray600.color
                public static let secondaryHovered = DSKitAsset.gray700.color
                public static let secondaryPressed = DSKitAsset.gray800.color
                public static let selected = DSKitAsset.primary50.color
                public static let inverse = DSKitAsset.baseWhite.color
            }
        }
        
        public enum Border {
            public static let primary = DSKitAsset.gray400.color
            public static let secondary = DSKitAsset.gray200.color
            public static let subtle = DSKitAsset.gray50.color
            public static let disabled = DSKitAsset.gray400.color
            
            public enum Interactive {
                public static let primary = DSKitAsset.primary500.color
                public static let primaryHovered = DSKitAsset.primary600.color
                public static let primaryPressed = DSKitAsset.primary700.color
                public static let secondary = DSKitAsset.gray600.color
                public static let secondaryHovered = DSKitAsset.gray700.color
                public static let secondaryPressed = DSKitAsset.gray800.color
                public static let danger = DSKitAsset.red600.color
                public static let dangerHovered = DSKitAsset.red700.color
                public static let dangerPressed = DSKitAsset.red800.color
                public static let selected = DSKitAsset.primary50.color
                public static let selectedHovered = DSKitAsset.primary100.color
                public static let selectedPressed = DSKitAsset.primary200.color
                public static let subtle = DSKitAsset.red50.color
                public static let subtleHovered = DSKitAsset.red100.color
                public static let subtlePressed = DSKitAsset.red200.color
            }
        }
    }
}

