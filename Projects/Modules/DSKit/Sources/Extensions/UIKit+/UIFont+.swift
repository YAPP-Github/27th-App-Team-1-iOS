//
//  UIFont+.swift
//  27th-App-Team-1-iOSManifests
//
//  Created by 최안용 on 1/13/26.
//

import UIKit

extension UIFont {
    /// NDGL 디자인 시스템에서 정의한 타이포그래피 스타일 가이드입니다.
    /// 모든 스타일은 Pretendard 폰트를 기본으로 하며, 행간(LineHeight)과 자간(Kern) 설정이 포함되어 있습니다.
    /// 각 case의 네이밍은 디자인 시스템의 네이밍을 사용하였습니다.
    public enum NDGL {
        // MARK: - Titles
        
        /// Title/Lg/Bold: 32pt / Bold / 행간 140% / 자간 -2.5%
        case titleLB
        /// Title/Lg/Semi Bold: 32pt / SemiBold / 행간 140% / 자간 -2.5%
        case titleLSB
        /// Title/Md/Bold: 22pt / Bold / 행간 140% / 자간 -2%
        case titleMB
        /// Title/Md/Semi Bold: 22pt / SemiBold / 행간 140% / 자간 -2%
        case titleMSB
        
        // MARK: - SubTitles
                
        /// Subtitle/Lg/Semi Bold: 20pt / SemiBold / 행간 140% / 자간 -2.5%
        case subTitleLSB
        /// Subtitle/Lg/Medium: 20pt / Medium / 행간 140% / 자간 -2.5%
        case subTitleLM
        /// Subtitle/Md/Bold: 18pt / Bold / 행간 130% / 자간 -2.5%
        case subTitleMB
        /// Subtitle/Md/Semi Bold: 18pt / SemiBold / 행간 130% / 자간 -2.5%
        case subTitleMSB
        /// Subtitle/Md/Medium: 18pt / Medium / 행간 130% / 자간 -2.5%
        case subTitleMM
        
        // MARK: - Body
                
        /// Body/Lg/Semi Bold: 16pt / SemiBold / 행간 130% / 자간 -2.5%
        case bodyLSB
        /// Body/Lg/Medium: 16pt / Medium / 행간 130% / 자간 -2.5%
        case bodyLM
        /// Body/Lg/Regular: 16pt / Regular / 행간 130% / 자간 -2.5%
        case bodyLR
        /// Body/Md/Semi Bold: 14pt / SemiBold / 행간 130% / 자간 -2.5%
        case bodyMSB
        /// Body/Md/Medium: 14pt / Medium / 행간 130% / 자간 -2.5%
        case bodyMM
        /// Body/Md/Regular: 14pt / Regular / 행간 130% / 자간 -2.5%
        case bodyMR
        /// Body/Sm/Semi Bold: 12pt / SemiBold / 행간 120% / 자간 -1%
        case bodySSB
        /// Body/Sm/Medium: 12pt / Medium / 행간 130% / 자간 -2.5%
        case bodySM
        /// Body/Sm/Regular: 12pt / Regular / 행간 130% / 자간 -2.5%
        case bodySR
        
        /// 해당 스타일의 프리텐다드 폰트 객체를 반환합니다.
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
    /// 해당 스타일의 행간 배수를 반환합니다.
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
    
    /// 해당 스타일의 자간 비율을 반환합니다.
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
    
    /// `UILabel`, `UITextView` 등의 `attributedText`에 적용할 속성 딕셔너리입니다.
    /// 폰트, 자간, 행간 및 중앙 정렬을 위한 baselineOffset이 포함되어 있습니다.
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
