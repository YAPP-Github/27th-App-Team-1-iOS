//
//  ServiceNoticeViewController.swift
//  MainFeature
//
//  Created by 최안용 on 2/23/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import DSKit

final class ServiceNoticeViewController: UIViewController {
    var termsHandler: (() -> Void)?
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let termsButton = UIButton()
    private let confirmButton = NDGLBtn(title: "확인했어요", style: .primary, size: .medium)
    private let containerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setStyle()
        setUI()
        setLayout()
        setAddTarget()
    }
}

private extension ServiceNoticeViewController {
    func setStyle() {
        view.backgroundColor = UIColor.init(hexCode: "#000000", alpha: 0.7)
        
        titleLabel.do {
            $0.numberOfLines = 2
            $0.setText(
                .subTitleLSB,
                text: "서비스 이용 전\n반드시 확인하세요.",
                color: DSKitAsset.Colors.black900.color,
                alignment: .center
            )
        }
        
        descriptionLabel.do {
            $0.numberOfLines = 0
            $0.setText(
                .bodyLM,
                text: "본 서비스는 AI 기술을 활용하여\n여행 정보를 분석·재구성하여 제공하는\n참고용 서비스입니다. 아래 내용을\n충분히 확인 후 이용해주세요.",
                color: DSKitAsset.Colors.black500.color,
                alignment: .center
            )
        }
        
        termsButton.do {
            var config = UIButton.Configuration.plain()
            config.contentInsets = .zero
            config.background = .clear()
            $0.configuration = config
            
            let title = "이용 약관 확인하기"
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.NDGL.bodyMM.font,
                .foregroundColor: DSKitAsset.Colors.black400.color,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .underlineColor: DSKitAsset.Colors.black400.color,
                .baselineOffset: 2.0
            ]
            
            $0.setAttributedTitle(NSAttributedString(string: title, attributes: attributes), for: .normal)
        }
        
        containerView.do {
            $0.backgroundColor = DSKitAsset.Colors.white.color
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
    }
    
    func setUI() {
        view.addSubview(containerView)
        containerView.addSubviews(titleLabel, descriptionLabel, termsButton, confirmButton)
    }
    
    func setLayout() {
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(314.adjusted)
            $0.height.equalTo(318.adjustedH)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28.adjustedH)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16.adjustedH)
            $0.centerX.equalToSuperview()
        }
        
        termsButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(12.adjustedH)
            $0.centerX.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(termsButton.snp.bottom).offset(28.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(28.adjusted)
        }
    }
    
    func setAddTarget() {
        termsButton.addTarget(self, action: #selector(termsButtonTapped), for: .touchUpInside)
        
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }

    @objc func termsButtonTapped() {
        termsHandler?()
    }

    @objc func confirmButtonTapped() {
        self.dismiss(animated: true)
    }
}
