//
//  CategoryCell.swift
//  HomeFeature
//
//  Created by kimnahun on 2026-01-22.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Core
import DSKit
import UIKit
import SnapKit
import Then

final class CategoryCell: UICollectionViewCell {

    static let identifier = "CategoryCell"

    // MARK: - UI Components

    private let containerView = UIView().then {
        $0.layer.borderWidth = 1
        $0.clipsToBounds = true
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

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded()
        containerView.layer.cornerRadius = containerView.bounds.height / 2
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
            $0.horizontalEdges.equalToSuperview().inset(14)
            $0.verticalEdges.equalToSuperview().inset(6)
        }

        iconImageView.snp.makeConstraints {
            $0.size.equalTo(20).priority(.high)    
        }
    }

    // MARK: - Configuration

    func configure(title: String, isSelected: Bool, isFirstItem: Bool) {
        titleLabel.setText(.bodyMSB, text: title, color: isSelected ? UIColor.NDGL.Text.Interactive.inverse :   UIColor(hexCode: "#757575"))
        iconImageView.isHidden = isFirstItem

        if isSelected {
            containerView.backgroundColor = UIColor(hexCode: "#2C2C2C")
            containerView.layer.borderColor = UIColor.clear.cgColor
            iconImageView.tintColor = .white
        } else {
            containerView.backgroundColor = UIColor.NDGL.Bg.primary
            containerView.layer.borderColor = UIColor.NDGL.Border.secondary.cgColor
            iconImageView.tintColor = UIColor.NDGL.Text.secondary
        }
    }
}
