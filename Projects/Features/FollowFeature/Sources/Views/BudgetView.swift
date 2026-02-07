//
//  BudgetView.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-01-23.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Core
import DSKit
import UIKit
import SnapKit
import Then

final class BudgetView: UIView {

    // MARK: - UI Components

    private let iconImageView = UIImageView().then {
        $0.image = DSKitAsset.Assets.icPiggybank1.image
        $0.tintColor = UIColor(hexCode: "#2C2C2C")
        $0.contentMode = .scaleAspectFit
    }

    private let titleLabel = UILabel()

    private let budgetLabel = UILabel()

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
        backgroundColor = UIColor(hexCode: "#F5F5F5")
        layer.cornerRadius = 8

        [iconImageView, titleLabel, budgetLabel].forEach {
            addSubview($0)
        }

        titleLabel.setText(.bodyMM, text: "1일차 여행 예산:", color: UIColor(hexCode: "#2C2C2C"))
    }

    private func setupConstraints() {
        iconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(20)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
        }

        budgetLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(4)
            $0.centerY.equalToSuperview()
        }
    }

    // MARK: - Configuration

    func configure(budget: Int) {
        budgetLabel.setText(.bodyMSB, text: "\(budget/10000)만원", color: UIColor(hexCode: "#111111"))
    }
}
