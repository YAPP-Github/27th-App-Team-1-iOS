//
//  UIColor+.swift
//  DSKit
//
//  Created by 최안용 on 1/21/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

extension UIColor {
    public enum NDGL {
        public enum Text {
            public static let primary = DSKitAsset.Colors.gray900.color
            public static let secondary = DSKitAsset.Colors.gray700.color
            public static let tertiary = DSKitAsset.Colors.gray500.color
            public static  let danger = DSKitAsset.Colors.red600.color
            public static let disabled = DSKitAsset.Colors.gray400.color
                
            public enum Interactive {
                public static let primary = DSKitAsset.Colors.primary500.color
                public static let primaryHovered = DSKitAsset.Colors.primary600.color
                public static let primaryPressed = DSKitAsset.Colors.primary700.color
                public static let secondary = DSKitAsset.Colors.gray600.color
                public static let secondaryHovered = DSKitAsset.Colors.gray700.color
                public static let secondaryPressed = DSKitAsset.Colors.gray800.color
                public static let inverse = DSKitAsset.Colors.baseWhite.color
            }
        }
        
        public enum Bg {
            public static let primary = DSKitAsset.Colors.baseWhite.color
            public static let disabled = DSKitAsset.Colors.gray300.color
            
            public enum Interactive {
                public static let primary = DSKitAsset.Colors.primary500.color
                public static let primaryHovered = DSKitAsset.Colors.primary600.color
                public static let primaryPressed = DSKitAsset.Colors.primary700.color
                public static let secondary = DSKitAsset.Colors.gray500.color
                public static let secondaryHovered = DSKitAsset.Colors.gray600.color
                public static let secondaryPressed = DSKitAsset.Colors.gray700.color
                public static let selected = DSKitAsset.Colors.primary50.color
                public static let selectedHovered = DSKitAsset.Colors.primary100.color
                public static let selectedPressed = DSKitAsset.Colors.primary200.color
                public static let subtle = DSKitAsset.Colors.red50.color
                public static let subtleHovered = DSKitAsset.Colors.red100.color
                public static let subtlePressed = DSKitAsset.Colors.red200.color
                public static let subtle02 = DSKitAsset.Colors.gray50.color
                public static let subtle02Hovered = DSKitAsset.Colors.gray100.color
                public static let subtle02Pressed = DSKitAsset.Colors.gray200.color
            }
        }
        
        public enum Icon {
            public static let primary = DSKitAsset.Colors.gray900.color
            public static let secondary = DSKitAsset.Colors.gray700.color
            public static let tertiary = DSKitAsset.Colors.gray500.color
            public static let danger = DSKitAsset.Colors.red700.color
            public static let disabled = DSKitAsset.Colors.gray400.color
            
            public enum Interactive {
                public static let primary = DSKitAsset.Colors.primary500.color
                public static let primaryHovered = DSKitAsset.Colors.primary600.color
                public static let primaryPressed = DSKitAsset.Colors.primary700.color
                public static let secondary = DSKitAsset.Colors.gray600.color
                public static let secondaryHovered = DSKitAsset.Colors.gray700.color
                public static let secondaryPressed = DSKitAsset.Colors.gray800.color
                public static let selected = DSKitAsset.Colors.primary50.color
                public static let inverse = DSKitAsset.Colors.baseWhite.color
            }
        }
        
        public enum Border {
            public static let primary = DSKitAsset.Colors.gray400.color
            public static let secondary = DSKitAsset.Colors.gray200.color
            public static let subtle = DSKitAsset.Colors.gray50.color
            public static let disabled = DSKitAsset.Colors.gray400.color
            
            public enum Interactive {
                public static let primary = DSKitAsset.Colors.primary500.color
                public static let primaryHovered = DSKitAsset.Colors.primary600.color
                public static let primaryPressed = DSKitAsset.Colors.primary700.color
                public static let secondary = DSKitAsset.Colors.gray600.color
                public static let secondaryHovered = DSKitAsset.Colors.gray700.color
                public static let secondaryPressed = DSKitAsset.Colors.gray800.color
                public static let danger = DSKitAsset.Colors.red600.color
                public static let dangerHovered = DSKitAsset.Colors.red700.color
                public static let dangerPressed = DSKitAsset.Colors.red800.color
                public static let selected = DSKitAsset.Colors.primary50.color
                public static let selectedHovered = DSKitAsset.Colors.primary100.color
                public static let selectedPressed = DSKitAsset.Colors.primary200.color
                public static let subtle = DSKitAsset.Colors.red50.color
                public static let subtleHovered = DSKitAsset.Colors.red100.color
                public static let subtlePressed = DSKitAsset.Colors.red200.color
            }
        }
    }
}
