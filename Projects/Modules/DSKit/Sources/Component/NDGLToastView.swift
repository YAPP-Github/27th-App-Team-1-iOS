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
        
        if let image = type.icon {
            iconImageView.image = image
        } else {
            iconImageView.isHidden = true
        }
        
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
        case normal
        
        var icon: UIImage? {
            switch self {
            case .success:
                return DSKitAsset.Assets.icCheck.image
            default: return nil
            }
        }
    }
}
