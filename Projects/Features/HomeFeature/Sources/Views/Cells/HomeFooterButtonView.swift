//
//  HomeFooterButtonView.swift
//  HomeFeature
//
//  Created by 최안용 on 1/31/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import DSKit

import RxCocoa
import RxSwift

final class HomeFooterButtonView: UICollectionReusableView {
    private let plusButton = UIButton()
    
    var disposeBag = DisposeBag()
    var plusBtnTapped: Observable<Void> {
        plusButton.rx.tap.asObservable()
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}

private extension HomeFooterButtonView {
    func setStyle() {
        plusButton.do {
            var configure = UIButton.Configuration.plain()
            let fontAttributes = UIFont.NDGL.bodyMSB.attributes
            configure.baseForegroundColor = DSKitAsset.Colors.black600.color
            configure.attributedTitle = AttributedString(
                "여행 따라가기 더보기",
                attributes: AttributeContainer(fontAttributes)
            )
            configure.background.cornerRadius = 8.adjustedH
            configure.background.strokeWidth = 1
            configure.background.strokeColor = DSKitAsset.Colors.black200.color
            $0.configuration = configure
        }
    }
    
    func setUI() {
        addSubview(plusButton)
    }
    
    func setLayout() {
        plusButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(40.adjustedH)
            $0.directionalHorizontalEdges.equalToSuperview()
        }
    }
}

