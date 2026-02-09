//
//  PlaceInfoRowView.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-02-10.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import DSKit
import SnapKit
import UIKit

// MARK: - PlaceInfoRowView

final class PlaceInfoRowView: UIView {

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()

    init(icon: UIImage?, iconColor: UIColor? = nil) {
        super.init(frame: .zero)
        setupUI()
        if let iconColor = iconColor {
            iconImageView.image = icon?.withRenderingMode(.alwaysTemplate)
            iconImageView.tintColor = iconColor
        } else {
            iconImageView.image = icon
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(iconImageView)
        addSubview(textLabel)

        iconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview().offset(2)
            $0.width.height.equalTo(20)
        }

        textLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
    }

    func configure(text: String) {
        let attributedText = NSAttributedString(
            string: text,
            attributes: UIFont.NDGL.bodyMR.attributes
        )
        textLabel.attributedText = attributedText
    }
}
