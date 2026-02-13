//
//  SettingMenuCell.swift
//  SettingFeature
//
//  Created by 최안용 on 2/10/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import DSKit

final class SettingMenuCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let chevronImageView = UIImageView()
    private let toggleSwitch = UISwitch()
    private let detailLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(
            by: .init(
                top: 0,
                left: 25.adjusted,
                bottom: 0,
                right: 24.adjusted
            )
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        detailLabel.text = nil
    }
    
    func configure(title: String, type: SettingCellType) {
        titleLabel.setText(.bodyLR, text: title, color: DSKitAsset.Colors.black700.color)
        
        [chevronImageView, toggleSwitch, detailLabel].forEach { $0.isHidden = true }
        
        switch type {
        case .toggle(let isOn):
            toggleSwitch.isHidden = false
            toggleSwitch.isOn = isOn
            self.selectionStyle = .none
            
        case .icon:
            chevronImageView.isHidden = false
            self.selectionStyle = .gray
            
        case .detailText(let text):
            detailLabel.isHidden = false
            detailLabel.setText(.bodyLR, text: text, color: DSKitAsset.Colors.black400.color)
            self.selectionStyle = .none
        }
    }
}

private extension SettingMenuCell {
    func setStyle() {
        self.backgroundColor = .clear
        
        chevronImageView.do {
            $0.image = DSKitAsset.Assets.icChevronRight2.image
            $0.contentMode = .scaleAspectFit
        }
        
        toggleSwitch.do {
            $0.onTintColor = DSKitAsset.Colors.green500.color
            $0.thumbTintColor = DSKitAsset.Colors.white.color
        }
    }
    
    func setUI() {
        contentView.addSubviews(titleLabel, chevronImageView, toggleSwitch, detailLabel)
    }
    
    func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(8.adjusted)
            $0.centerY.equalToSuperview()
        }
        
        chevronImageView.snp.makeConstraints {
            $0.size.equalTo(24.adjustedH)
        }
                
        [chevronImageView, toggleSwitch, detailLabel].forEach { view in
            view.snp.makeConstraints {
                $0.trailing.equalToSuperview().inset(8.adjusted)
                $0.centerY.equalToSuperview()
            }
        }
    }
}
