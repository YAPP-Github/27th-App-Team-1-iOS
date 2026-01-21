//
//  UIFont+.swift
//  27th-App-Team-1-iOSManifests
//
//  Created by 최안용 on 1/13/26.
//

import UIKit

extension UIFont {
    public enum NDGL {
        // Titles
        case titleLB // 행간 140%, 자간 -2.5%
        case titleLSB // 행간 140%, 자간 -2.5%
        case titleMB // 행간 140%, 자간 -2%
        case titleMSB // 행간 140%, 자간 -2%
        
        // SubTitles
        case subTitleLSB // 행간 140%, 자간 -2.5%
        case subTitleLM // 행간 140%, 자간 -2.5%
        case subTitleMB // 행간 130%, 자간 -2.5%
        case subTitleMSB // 행간 130%, 자간 -2.5%
        case subTitleMM // 행간 130%, 자간 -2.5%
        
        // Body
        case bodyLSB // 행간 130%, 자간 -2.5%
        case bodyLM // 행간 130%, 자간 -2.5%
        case bodyLR // 행간 130%, 자간 -2.5%
        case bodyMSB // 행간 130%, 자간 -2.5%
        case bodyMM // 행간 130%, 자간 -2.5%
        case bodyMR // 행간 130%, 자간 -2.5%
        case bodySSB // 행간 120%, 자간 -1%
        case bodySM // 행간 130%, 자간 -2.5%
        case bodySR // 행간 130%, 자간 -2.5%
        
        private var font: UIFont {
            switch self {
            case .titleLB:
                return DSKitFontFamily.Pretendard.bold.font(size: 32)
            case .titleLSB:
                return DSKitFontFamily.Pretendard.semiBold.font(size: 32)
            case .titleMB:
                return DSKitFontFamily.Pretendard.bold.font(size: 22)
            case .titleMSB:
                return DSKitFontFamily.Pretendard.semiBold.font(size: 22)
            case .subTitleLSB:
                return DSKitFontFamily.Pretendard.semiBold.font(size: 20)
            case .subTitleLM:
                return DSKitFontFamily.Pretendard.medium.font(size: 20)
            case .subTitleMB:
                return DSKitFontFamily.Pretendard.bold.font(size: 18)
            case .subTitleMSB:
                return DSKitFontFamily.Pretendard.semiBold.font(size: 18)
            case .subTitleMM:
                return DSKitFontFamily.Pretendard.medium.font(size: 18)
            case .bodyLSB:
                return DSKitFontFamily.Pretendard.semiBold.font(size: 16)
            case .bodyLM:
                return DSKitFontFamily.Pretendard.medium.font(size: 16)
            case .bodyLR:
                return DSKitFontFamily.Pretendard.regular.font(size: 16)
            case .bodyMSB:
                return DSKitFontFamily.Pretendard.semiBold.font(size: 14)
            case .bodyMM:
                return DSKitFontFamily.Pretendard.medium.font(size: 14)
            case .bodyMR:
                return DSKitFontFamily.Pretendard.regular.font(size: 14)
            case .bodySSB:
                return DSKitFontFamily.Pretendard.semiBold.font(size: 12)
            case .bodySM:
                return DSKitFontFamily.Pretendard.medium.font(size: 12)
            case .bodySR:
                return DSKitFontFamily.Pretendard.regular.font(size: 12)
            }
        }
    }
}

extension UIFont.NDGL {
    private var lineHeightMultiple: CGFloat {
        switch self {
        // Titles
        case .titleLB, .titleLSB, .titleMB, .titleMSB:
            return 1.4
            
        // SubTitles
        case .subTitleLSB, .subTitleLM:
            return 1.4
        case .subTitleMB, .subTitleMSB, .subTitleMM:
            return 1.3
            
        // Body
        case .bodyLSB, .bodyLM, .bodyLR, .bodyMSB, .bodyMM, .bodyMR, .bodySM, .bodySR:
            return 1.3
        case .bodySSB:
            return 1.2
        }
    }
    
    private var kern: CGFloat {
        switch self {
        case .titleMB, .titleMSB:
            return -0.02
        case .bodySSB:
            return -0.01
        default:
            return -0.025
        }
    }
    
    public var attributes: [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        let targetHeight = font.pointSize * lineHeightMultiple
        
        paragraphStyle.minimumLineHeight = targetHeight
        paragraphStyle.maximumLineHeight = targetHeight
        
        let baselineOffset = (targetHeight - font.lineHeight) / 2

        return [
            .font: font,
            .kern: font.pointSize * kern,
            .paragraphStyle: paragraphStyle,
            .baselineOffset: baselineOffset
        ]
    }
}
