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
        backgroundColor = UIColor(hexCode: "#FFFFFF")
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor(hexCode: "#D9D9D9").cgColor

        [iconImageView, titleLabel, budgetLabel].forEach {
            addSubview($0)
        }

        titleLabel.setText(.bodyMM, text: "1인 기준 여행 예산 :", color: UIColor(hexCode: "#2C2C2C"))
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
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formattedNumber = formatter.string(from: NSNumber(value: budget)) ?? "\(budget)"
        budgetLabel.setText(.bodyMSB, text: "\(formattedNumber)원", color: UIColor(hexCode: "#111111"))
    }
}
