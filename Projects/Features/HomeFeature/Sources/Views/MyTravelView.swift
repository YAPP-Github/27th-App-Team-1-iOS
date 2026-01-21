//
//  MyTravelView.swift
//  HomeFeature
//
//  Created by kimnahun on 1/22/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Core
import DSKit
import UIKit
import SnapKit
import Then

final class MyTravelView: UIView {

    private let messageLabel = UILabel().then {
        $0.setText(.bodyLSB, text: "아직 등록된 여행지가 없어요", color: UIColor.NDGL.Text.primary)
    }
    private let subMessageLabel = UILabel().then {
        $0.setText(.bodyMM, text: "새 여행 일정을 만들어 보세요!", color: UIColor.NDGL.Text.disabled)
    }
    
    private let imageView = UIImageView(image: DSKitAsset.Assets.icAirplane1.image)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        backgroundColor = UIColor.NDGL.Bg.primary
        layer.cornerRadius = 4
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.init(hexCode: "#F1F1F1").cgColor

        addSubview(messageLabel)
        addSubview(subMessageLabel)
        addSubview(imageView)

    }

    private func setupConstraints() {
        messageLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(17.5)
            $0.leading.equalToSuperview().offset(16)
        }
        subMessageLabel.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(6)
            $0.leading.equalTo(messageLabel)
        }
        imageView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(-8.19)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(63.63)
        }
    }
}
