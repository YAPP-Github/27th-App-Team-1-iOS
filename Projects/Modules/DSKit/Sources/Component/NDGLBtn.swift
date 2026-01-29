//
//  NDGLBtn.swift
//  DSKit
//
//  Created by 최안용 on 1/24/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import SnapKit
import Then

/// NDGL 디자인 시스템의 표준 버튼 컴포넌트입니다.
///
/// `UIButton.Configuration`을 기반으로 하며, 스타일(배경/테두리 타입)과 사이즈(높이/폰트)를 조합하여 사용합니다.
/// 상태 변경(Normal, Highlighted, Disabled)에 따른 시각적 피드백이 자동 적용됩니다.
///
/// ### Example
/// ```swift
/// let button = NDGLBtn(
///     title: "확인",
///     style: .primary,
///     size: .large,
///     iconImage: DSKitAsset.Assets.icCheck.image,
///     iconAlignment: .leading
/// )
///
/// /// // 타이틀 변경
/// button.updateTitle("뒤로가기")
/// ```
public final class NDGLBtn: UIButton {
    // MARK: - UI Components
    
    private var title: String
    private let style: NDGLBtnStyle
    private let size: NDGLBtnSize
    private let iconImage: UIImage?
    private let iconAlignment: NSDirectionalRectEdge?
    
    /// NDGLBtn을 초기화합니다.
    /// - Parameters:
    ///   - title: 버튼에 표시될 텍스트
    ///   - style: 버튼의 배경색과 전경색 스타일 (primary, secondary, destructive)
    ///   - size: 버튼의 높이, 폰트, 아이콘 크기를 결정하는 사이즈 (large, medium, small)
    ///   - iconImage: 버튼에 포함될 아이콘 이미지 (기본값: nil)
    ///   - iconAlignment: 아이콘의 배치 방향 (.leading, .trailing 등 / 기본값: nil)
    public init(
        title: String,
        style: NDGLBtnStyle,
        size: NDGLBtnSize,
        iconImage: UIImage? = nil,
        iconAlignment: NSDirectionalRectEdge? = nil,
    ) {
        self.title = title
        self.style = style
        self.size = size
        self.iconImage = iconImage
        self.iconAlignment = iconAlignment
        super.init(frame: .zero)
        
        setUI()
        setAppearance()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 버튼의 타이틀 텍스트를 변경합니다.
    /// - Parameter newTitle: 새로 적용할 텍스트 문자열
    public func updateTitle(_ newTitle: String) {
        self.title = newTitle
        self.setNeedsUpdateConfiguration()
    }
}

// MARK: - Private Extension

private extension NDGLBtn {
    func setUI() {
        configuration = UIButton.Configuration.plain()
        configuration?.background.cornerRadius = 8.adjustedH
        
        if let icon = self.iconImage, let alignment = self.iconAlignment {
            let resizedIcon = icon.resize(targetSize: self.size.iconSize)
            configuration?.image = resizedIcon.withRenderingMode(.alwaysTemplate)
            configuration?.imagePlacement = alignment
            configuration?.imagePadding = self.size.iconSpacing
        }
    }
    
    func setAppearance() {
        let buttonStateHandler: UIButton.ConfigurationUpdateHandler = { [weak self] button in
            guard let self else { return }
            var updatedConfiguration = button.configuration
            let foregroundColor: UIColor
            let backgroundColor: UIColor
                                    
            switch button.state {
            case .disabled:
                backgroundColor = UIColor(hexCode: "#B3B3B3")
                foregroundColor = UIColor(hexCode: "#757575")
            case .highlighted:
                backgroundColor = self.style.backgroundColor.withAlphaComponent(0.9)
                foregroundColor = self.style.contentsColor.withAlphaComponent(0.9)
            default:
                backgroundColor = self.style.backgroundColor
                foregroundColor = self.style.contentsColor
            }
            
            updatedConfiguration?.background.backgroundColor = backgroundColor
            updatedConfiguration?.baseForegroundColor = foregroundColor
            
            var fontAttributes = self.size.font.attributes
            fontAttributes[.foregroundColor] = foregroundColor
            
            updatedConfiguration?.attributedTitle = AttributedString(
                self.title,
                attributes: AttributeContainer(fontAttributes)
            )
            
            if self.style == .outline {
                updatedConfiguration?.background.strokeWidth = 1.0
                updatedConfiguration?.background.strokeColor = self.style.strokeColor
            }
            
            button.configuration = updatedConfiguration
        }
        
        self.configurationUpdateHandler = buttonStateHandler
    }
    
    func setLayout() {
        if let height = self.size.height {
            self.snp.makeConstraints {
                $0.height.equalTo(height).priority(.high)
            }
        }
    }
}

// MARK: - NDGLBtn 스타일 정의

/// NDGL 버튼의 시각적 스타일을 정의하는 열거형입니다.
public enum NDGLBtnStyle {
    /// 검정 배경에 흰색 텍스트
    case primary
    /// 연회색 배경에 진회색 텍스트
    case secondary
    /// 연빨강 배경에 빨간색 텍스트
    case destructive
    /// 흰 배경에 검정 텍스트 및 회색 아웃라인
    case outline
    
    /// 스타일별 전경색(텍스트 및 아이콘)
    var contentsColor: UIColor {
        switch self {
        case .primary: UIColor(hexCode: "#FFFFFF")
        case .secondary: UIColor(hexCode: "#2C2C2C")
        case .destructive: UIColor(hexCode: "#FB2C36")
        case .outline: UIColor(hexCode: "#383838")
        }
    }

    /// 스타일별 배경색
    var backgroundColor: UIColor {
        switch self {
        case .primary: UIColor(hexCode: "#111111")
        case .secondary: UIColor(hexCode: "#F5F5F5")
        case .destructive: UIColor(hexCode: "#FEF2F2")
        case .outline: UIColor(hexCode: "#FFFFFF")
        }
    }

    /// `outline` 스타일 시 적용되는 테두리 컬러
    var strokeColor: UIColor {
        UIColor(hexCode: "#D9D9D9")
    }
}

/// NDGL 버튼의 크기 규격(높이, 폰트 등)을 정의하는 열거형입니다.
public enum NDGLBtnSize {
    /// 높이 56pt, Body Large SemiBold
    case large
    /// 높이 40pt, Body Medium SemiBold
    case medium
    /// 높이 자동(nil), Body Small SemiBold
    case small
    
    /// 사이즈별 고정 높이 값
    var height: CGFloat? {
        switch self {
        case .large: 56.adjustedH
        case .medium: 40.adjustedH
        case .small: nil
        }
    }
    
    /// 사이즈별 적용 폰트
    var font: UIFont.NDGL {
        switch self {
        case .large: .bodyLSB
        case .medium: .bodyMSB
        case .small: .bodySSB
        }
    }
    
    /// 사이즈별 아이콘 프레임 크기
    var iconSize: CGFloat {
        switch self {
        case .large: 24.adjusted
        case .medium: 20.adjusted
        case .small: 16.adjusted
        }
    }
    
    /// 아이콘과 텍스트 사이의 간격
    var iconSpacing: CGFloat {
        switch self {
        case .large, .medium: 8
        case .small: 4
        }
    }
}
