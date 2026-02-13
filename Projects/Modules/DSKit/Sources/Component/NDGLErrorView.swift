//
//  NDGLErrorView.swift
//  DSKit
//
//  Created by 최안용 on 2/10/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import RxSwift

public final class NDGLErrorView: UIView {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let button = NDGLBtn(title: "다시 시도", style: .primary, size: .large)
    private let titleStackView = UIStackView()
    private let containerStackView = UIStackView()
    
    public var buttonDidTap: Observable<Void> {
        button.rx.tap.asObservable()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension NDGLErrorView {
    func setStyle() {
        imageView.do {
            $0.image = DSKitAsset.Assets.icServerError.image
            $0.contentMode = .scaleAspectFit
        }
        
        titleLabel.do {
            $0.setText(
                .titleMSB,
                text: "정보를 불러올 수 없어요",
                color: DSKitAsset.Colors.black700.color,
                alignment: .center
            )
        }
        
        subtitleLabel.do {
            $0.setText(
                .bodyLM,
                text: "인터넷 연결 확인 후 다시 시도해 주세요",
                color: DSKitAsset.Colors.black500.color,
                alignment: .center
            )
        }
        
        titleStackView.do {
            $0.axis = .vertical
            $0.spacing = 10.adjustedH
            $0.alignment = .center
        }
        
        containerStackView.do {
            $0.axis = .vertical
            $0.spacing = 16.adjustedH
            $0.alignment = .center
        }
    }
    
    func setUI() {
        titleStackView.addArrangedSubviews(titleLabel, subtitleLabel)
        containerStackView.addArrangedSubviews(imageView, titleStackView)
        addSubviews(containerStackView, button)
    }
    
    func setLayout() {
        imageView.snp.makeConstraints {
            $0.size.equalTo(140.adjustedH)
        }
        
        containerStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(button.snp.top).dividedBy(2)
        }
        
        button.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(24.adjusted)
            $0.bottom.equalToSuperview().inset(16.adjustedH)
        }
    }
}
