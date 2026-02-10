//
//  CategoryChipCell.swift
//  DSKit
//
//  Created by 최안용 on 1/30/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

public final class CategoryChipCell: UICollectionViewCell {
    public static let defaultHeight = 30.adjustedH
    
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let stackView = UIStackView()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        
        iconView.image = nil
        titleLabel.text = nil
    }
    
    public func configure(_ icon: ChipIconType, _ title: String, _ isSelected: Bool = false) {
        let contentColor = isSelected ? DSKitAsset.Colors.white.color : DSKitAsset.Colors.black400.color
        iconView.do {
            $0.image = icon.image
            $0.tintColor = contentColor
            $0.isHidden = icon == .none
        }
        
        titleLabel.setText(
            .bodyMM,
            text: title,
            color: contentColor,
            alignment: .center
        )
        
        contentView.layer.borderWidth = isSelected ? 0.0 : 1.0
        contentView.backgroundColor = isSelected ? DSKitAsset.Colors.black900.color : DSKitAsset.Colors.white.color
        
        stackView.snp.updateConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(icon.horizontalPadding)
        }
    }
}

private extension CategoryChipCell {
    func setStyle() {
        contentView.do {
            $0.layer.cornerRadius = 15.adjustedH
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = DSKitAsset.Colors.black200.color.cgColor
            $0.clipsToBounds = true
        }
        
        iconView.do {
            $0.contentMode = .scaleAspectFit
        }
        
        titleLabel.do {
            $0.numberOfLines = 1
        }
        
        stackView.do {
            $0.axis = .horizontal
            $0.spacing = 4
            $0.alignment = .center
            $0.isUserInteractionEnabled = false
        }
    }
    
    func setUI() {
        stackView.addArrangedSubviews(iconView, titleLabel)
        contentView.addSubview(stackView)
    }
    
    func setLayout() {
        stackView.snp.makeConstraints {
            $0.height.equalTo(20.adjustedH)
            $0.centerY.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview().inset(14.adjusted)
        }
        
        iconView.snp.makeConstraints {
            $0.size.equalTo(20.adjustedH)
        }
    }
}

public enum ChipIconType {
    case none
    case youtube
    case tv
    
    fileprivate var image: UIImage? {
        switch self {
        case .none:
            return nil
        case .youtube:
            return DSKitAsset.Assets.icVideo1.image.withRenderingMode(.alwaysTemplate)
        case .tv:
            return DSKitAsset.Assets.icTv1.image.withRenderingMode(.alwaysTemplate)
        }
    }
    
    fileprivate var horizontalPadding: CGFloat {
        switch self {
        case .none:
            return 23.5
        case .youtube, .tv:
            return 14.adjusted
        }
    }
}
