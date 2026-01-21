//
//  CategoryCell.swift
//  HomeFeature
//
//  Created by kimnahun on 2026-01-22.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit
import DSKit
import SnapKit
import Then

final class CategoryCell: UICollectionViewCell {

    static let identifier = "CategoryCell"

    // MARK: - UI Components

    private let containerView = UIView().then {
        $0.layer.cornerRadius = 18
        $0.layer.borderWidth = 1
    }

    private let iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(systemName: "play.rectangle.fill")
    }

    private let titleLabel = UILabel()

    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(stackView)
        [iconImageView, titleLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }

    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().offset(12)
            $0.trailing.lessThanOrEqualToSuperview().offset(-12)
        }

        iconImageView.snp.makeConstraints {
            $0.size.equalTo(16)
        }
    }

    // MARK: - Configuration

    func configure(title: String, isSelected: Bool) {
        titleLabel.setText(.bodyMSB, text: title, color: isSelected ? .white : UIColor.NDGL.Text.secondary)

        if isSelected {
            containerView.backgroundColor = .black
            containerView.layer.borderColor = UIColor.clear.cgColor
            iconImageView.tintColor = .white
            iconImageView.isHidden = false
        } else {
            containerView.backgroundColor = .white
            containerView.layer.borderColor = UIColor.NDGL.Border.secondary.cgColor
            iconImageView.isHidden = true
        }
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        attributes.size.height = 36
        return attributes
    }
}
