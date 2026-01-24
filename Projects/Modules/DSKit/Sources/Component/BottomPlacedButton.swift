//
//  BottomPlacedButton.swift
//  DSKit
//
//  Created by kimnahun on 2026-01-24.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Core
import SnapKit
import UIKit

public final class BottomPlacedButton: UIButton {

    // MARK: - Properties

    private let iconImageView = UIImageView()
    private let titleTextLabel = UILabel()
    private let contentStackView = UIStackView()

    // MARK: - Initialization

    public init(title: String, icon: DSKitImages? = nil) {
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
        configure(title: title, icon: icon)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        backgroundColor = UIColor.init(hexCode: "#111111")
        layer.cornerRadius = 8

        contentStackView.axis = .horizontal
        contentStackView.spacing = 8
        contentStackView.alignment = .center
        contentStackView.isUserInteractionEnabled = false

        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = UIColor.NDGL.Text.Interactive.inverse
        iconImageView.isUserInteractionEnabled = false

        titleTextLabel.isUserInteractionEnabled = false

        addSubview(contentStackView)
        contentStackView.addArrangedSubview(iconImageView)
        contentStackView.addArrangedSubview(titleTextLabel)
    }

    private func setupConstraints() {
        contentStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        iconImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
    }

    // MARK: - Configuration

    public func configure(title: String, icon: DSKitImages? = nil) {
        titleTextLabel.setText(
            .subTitleMSB,
            text: title,
            color: UIColor.NDGL.Text.Interactive.inverse
        )

        if let icon = icon {
            iconImageView.image = icon.image
            iconImageView.isHidden = false
        } else {
            iconImageView.isHidden = true
        }
    }

    // MARK: - Touch Handling

    public override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.7 : 1.0
        }
    }
}
