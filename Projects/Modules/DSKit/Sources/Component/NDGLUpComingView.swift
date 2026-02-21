//
//  NDGLUpComingView.swift
//  DSKit
//
//  Created by kimnahun on 2026-02-22.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import Kingfisher
import SnapKit
import Then

public final class NDGLUpComingView: UIView {
    private let imageView = UIImageView()
    private let badge = UIView()
    private let dDayLabel = UILabel()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let titleStackView = UIStackView()
    private let infoStackView = UIStackView()
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

    public func configure(title: String, date: String, dDay: Int, imageUrl: String) {
        titleLabel.setText(.subTitleMSB, text: title, color: DSKitAsset.Colors.black700.color)
        dateLabel.setText(.bodyMR, text: date, color: DSKitAsset.Colors.black600.color)
        dDayLabel.setText(.bodyMM, text: "D-\(dDay)", color: DSKitAsset.Colors.black400.color)

        if let url = URL(string: imageUrl) {
            imageView.kf.setImage(with: url)
        } else {
            imageView.backgroundColor = .systemGray5
        }
    }

    public func prepareForReuse() {
        imageView.kf.cancelDownloadTask()
        titleLabel.text = nil
        dateLabel.text = nil
        dDayLabel.text = nil
        imageView.image = nil
    }
}

private extension NDGLUpComingView {
    func setStyle() {
        backgroundColor = .clear

        imageView.do {
            $0.layer.cornerRadius = 64.adjustedH / 2
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
        }

        badge.do {
            $0.backgroundColor = DSKitAsset.Colors.black100.color
            $0.layer.cornerRadius = 26.adjustedH / 2
            $0.clipsToBounds = true
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
            $0.setContentHuggingPriority(.required, for: .horizontal)
        }

        titleLabel.do {
            $0.numberOfLines = 1
            $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }

        titleStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8.adjusted
            $0.alignment = .center
        }

        infoStackView.do {
            $0.axis = .vertical
            $0.spacing = 6.adjustedH
            $0.alignment = .leading
        }

        stackView.do {
            $0.axis = .horizontal
            $0.spacing = 12.adjusted
            $0.alignment = .center
        }
    }

    func setUI() {
        badge.addSubview(dDayLabel)
        titleStackView.addArrangedSubviews(badge, titleLabel)
        infoStackView.addArrangedSubviews(titleStackView, dateLabel)
        stackView.addArrangedSubviews(imageView, infoStackView)
        addSubview(stackView)
    }

    func setLayout() {
        imageView.snp.makeConstraints {
            $0.size.equalTo(64.adjustedH)
        }

        dDayLabel.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(12.adjusted)
            $0.directionalVerticalEdges.equalToSuperview().inset(4.adjustedH)
        }

        stackView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(16.adjusted)
            $0.directionalVerticalEdges.equalToSuperview().inset(8.adjustedH).priority(.high)
        }
    }
}
