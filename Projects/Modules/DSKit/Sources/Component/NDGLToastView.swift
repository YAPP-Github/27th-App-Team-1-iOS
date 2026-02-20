//
//  NDGLToastView.swift
//  DSKit
//
//  Created by 최안용 on 2/20/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

public final class NDGLToastView: UIView {
    private let type: ToastType
    private let message: String
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let stackView = UIStackView()
    
    public init(type: ToastType, message: String) {
        self.type = type
        self.message = message
        super.init(frame: .zero)
            
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension NDGLToastView {
    func setStyle() {
        self.do {
            $0.backgroundColor = DSKitAsset.Colors.black500.color
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 8.0
        }
        
        iconImageView.image = type.icon
        
        titleLabel.setText(.bodyMSB, text: message, color: DSKitAsset.Colors.white.color)
        
        stackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 8.adjusted
        }
    }
    
    func setUI() {
        addSubview(stackView)
        stackView.addArrangedSubviews(iconImageView, titleLabel)
    }
    
    func setLayout() {
        iconImageView.snp.makeConstraints {
            $0.size.equalTo(24.adjustedH)
        }
        
        stackView.snp.makeConstraints {
            $0.directionalVerticalEdges.equalToSuperview().inset(11.adjustedH)
            $0.directionalHorizontalEdges.equalToSuperview().inset(12.adjusted)
        }
    }
}

public extension NDGLToastView {
    enum ToastType {
        case success
        case place
        case transport
        case delete
        
        var icon: UIImage {
            switch self {
            case .success:
                // 아직 아이콘 추가 안됨
                return DSKitAsset.Assets.icStarFill1.image
            case .place:
                return DSKitAsset.Assets.icBag1.image.withTintColor(DSKitAsset.Colors.green500.color, renderingMode: .alwaysTemplate)
            case .transport:
                return DSKitAsset.Assets.icBus2.image.withTintColor(DSKitAsset.Colors.white.color, renderingMode: .alwaysTemplate)
            case .delete:
                return DSKitAsset.Assets.icTrash1.image
            }
        }
    }
}
