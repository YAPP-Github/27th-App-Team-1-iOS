//
//  NDGLTabItem.swift
//  TabBarFeature
//
//  Created by 최안용 on 1/23/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

final class NDGLTabItem: UIControl {
    private let containerStackView = UIStackView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    
    var isTabSelected: Bool = false {
        didSet {
            guard oldValue != isTabSelected else { return }
            updateState(animation: true)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(title: String, image: UIImage) {
        iconView.image = image
        titleLabel.setText(.bodyLM, text: title, color: UIColor(hexCode: "#FFFFFF"))
        updateState(animation: false)
    }
}

private extension NDGLTabItem {
    func setStyle() {
        containerStackView.do {
            $0.axis = .horizontal
            $0.spacing = 4.adjusted
            $0.alignment = .center
            $0.isUserInteractionEnabled = false
        }
        
        iconView.do {
            $0.contentMode = .scaleAspectFit
        }
        
        titleLabel.do {
            $0.setContentHuggingPriority(.required, for: .horizontal)
        }
    }
    
    func setUI() {
        containerStackView.addArrangedSubviews(iconView, titleLabel)
        addSubview(containerStackView)
    }
    
    func setLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(56.adjusted).priority(.high)
        }

        containerStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        iconView.snp.makeConstraints {
            $0.size.equalTo(24.adjusted)
        }
    }

    func updateState(animation: Bool) {
        let duration = animation ? 0.4 : 0.0

        self.snp.updateConstraints {
            $0.width.equalTo(isTabSelected ? 184.adjusted : 56.adjusted).priority(.high)
        }
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            self.titleLabel.isHidden = !self.isTabSelected
            self.titleLabel.alpha = self.isTabSelected ? 1 : 0
            
            self.iconView.tintColor = self.isTabSelected
            ? UIColor(hexCode: "#FFFFFF")
            : UIColor(hexCode: "#2C2C2C")
            
            self.containerStackView.layoutIfNeeded()
            
            self.superview?.layoutIfNeeded()
        }
    }
}
