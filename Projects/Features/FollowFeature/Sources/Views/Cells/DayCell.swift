//
//  DayCell.swift
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

final class DayCell: UICollectionViewCell {

    static let identifier = "DayCell"

    // MARK: - UI Components

    private let containerView = UIView().then {
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.NDGL.Border.primary.cgColor
        $0.backgroundColor = UIColor.NDGL.Bg.primary
    }

    private let dayLabel = UILabel()

    // MARK: - Properties

    override var isSelected: Bool {
        didSet {
            updateSelectionState()
        }
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
        containerView.addSubview(dayLabel)
    }

    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        dayLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    // MARK: - Configuration

    func configure(day: Int) {
        dayLabel.setText(.bodyMM, text: "\(day)일차", color: UIColor.NDGL.Text.secondary)
        updateSelectionState()
    }

    private func updateSelectionState() {
        if isSelected {
            containerView.backgroundColor = UIColor.NDGL.Bg.Interactive.secondary
            containerView.layer.borderColor = UIColor.clear.cgColor
            dayLabel.setText(.bodyMSB, text: dayLabel.text ?? "", color: UIColor.NDGL.Text.Interactive.inverse)
        } else {
            containerView.backgroundColor = UIColor.NDGL.Bg.primary
            containerView.layer.borderColor = UIColor.NDGL.Border.primary.cgColor
            dayLabel.setText(.bodyMM, text: dayLabel.text ?? "", color: UIColor.NDGL.Text.secondary)
        }
    }
}
