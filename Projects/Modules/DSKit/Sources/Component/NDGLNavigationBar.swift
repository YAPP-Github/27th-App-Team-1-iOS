//
//  NDGLNavigationBar.swift
//  DSKit
//
//  Created by 최안용 on 1/26/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

/// NDGL 프로젝트에서 공통으로 사용하는 커스텀 내비게이션 바입니다.
///
/// 좌측 버튼(1개), 중앙 타이틀, 우측 버튼(최대 2개)으로 구성되며,
/// 아이콘 유무에 따라 자동으로 레이아웃 여백을 조절합니다.
/// /// ### Example
/// ```swift
/// // 1. 기본 스타일 (뒤로가기 버튼 + 중앙 타이틀)
/// let naviBar = NDGLNavigationBar(
///     style: .white,
///     title: "프로필 수정",
///     leadingIcon: DSKitAsset.Assets.icBack.image
/// )
///
/// // 2. 우측 버튼이 있는 스타일 (타이틀 + 우측 아이콘 2개)
/// let naviBar = NDGLNavigationBar(
///     title: "알림",
///     trailingIcon: DSKitAsset.Assets.icBell.image,
///     trailing2Icon: DSKitAsset.Assets.icSetting.image
/// )
///
/// // 3. Rx를 이용한 액션 바인딩
/// naviBar.leadingButtonDidTap
///     .observe(on: MainScheduler.instance)
///     .subscribe(onNext: { [weak self] in
///         self?.navigationController?.popViewController(animated: true)
///     })
///     .disposed(by: disposeBag)
/// ```
public final class NDGLNavigationBar: UIView {
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let leadingButton = UIButton()
    private let leftSpacer = UIView()
    private let trailingButton = UIButton()
    private let trailing2Button = UIButton()
    private let rightSpacer = UIView()
    private let containerStackView = UIStackView()
  
    // MARK: - Rx Events
        
    /// 좌측 버튼 탭 이벤트
    public var leadingButtonDidTap: Observable<Void> {
        leadingButton.rx.tap.asObservable()
    }
    
    /// 우측 첫 번째 버튼 탭 이벤트
    public var trailingButtonDidTap: Observable<Void> {
        trailingButton.rx.tap.asObservable()
    }
    
    /// 우측 두 번째 버튼 탭 이벤트
    public var trailing2ButtonDidTap: Observable<Void> {
        trailing2Button.rx.tap.asObservable()
    }
  
    // MARK: - Initializer
    
    /// NDGLNavigationBar를 초기화합니다.
    /// - Parameters:
    ///   - style: 내비게이션 바의 배경 스타일 (.white, .gray)
    ///   - title: 중앙에 표시될 텍스트
    ///   - leadingIcon: 좌측에 표시될 아이콘 이미지
    ///   - trailingIcon: 우측 첫 번째 자리에 표시될 아이콘 이미지
    ///   - trailing2Icon: 우측 두 번째 자리에 표시될 아이콘 이미지
    public init(
        style: NDGLNavigationBarStyle = .white,
        title: String? = nil,
        leadingIcon: UIImage? = nil,
        trailingIcon: UIImage? = nil,
        trailing2Icon: UIImage? = nil
    ) {
        super.init(frame: .zero)
        
        setStyle(style, title, leadingIcon, trailingIcon, trailing2Icon)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extension

private extension NDGLNavigationBar {
    func setStyle(
        _ style: NDGLNavigationBarStyle,
        _ title: String?,
        _ leading: UIImage?,
        _ trailing: UIImage?,
        _ trailing2: UIImage?
    ) {
        if let title {
            titleLabel.setText(
                .bodyLM,
                text: title,
                color: DSKitAsset.Colors.black700.color,
                alignment: .center
            )
        }
        
        let normalColor = DSKitAsset.Colors.black600.color
        
        [(leadingButton, leading), (trailingButton, trailing), (trailing2Button, trailing2)]
            .forEach { button, image in
                var config = UIButton.Configuration.plain()
                config.image = image?.resize(targetSize: 28.adjustedH).withRenderingMode(.alwaysTemplate)
                config.baseForegroundColor = normalColor
                button.configuration = config
                button.isHidden = (image == nil)
            }
        
        rightSpacer.isHidden = trailing != nil || trailing2 != nil
        leftSpacer.isHidden = leading != nil
        
        self.backgroundColor = style.backgroundColor
        
        containerStackView.do {
            $0.axis = .horizontal
            $0.spacing = 4
            $0.alignment = .center
        }
    }

    func setUI() {
        containerStackView.addArrangedSubviews(
            leadingButton,
            leftSpacer,
            titleLabel,
            rightSpacer,
            trailingButton,
            trailing2Button
        )
        
        addSubview(containerStackView)
    }
    
    func setLayout() {
        [leadingButton, trailingButton, trailing2Button].forEach {
            $0.snp.makeConstraints { $0.size.equalTo(40.adjustedH) }
        }
        
        leftSpacer.snp.makeConstraints {
            $0.size.equalTo(40.adjustedH)
        }
        
        rightSpacer.snp.makeConstraints {
            $0.size.equalTo(40.adjustedH)
        }
        
        titleLabel.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(195.adjusted)
        }
        
        containerStackView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
            $0.directionalVerticalEdges.equalToSuperview().inset(4)
        }
        
        self.snp.makeConstraints {
            $0.height.equalTo(48.adjustedH)
        }
    }
}

/// 내비게이션 바의 배경색 스타일 정의
public enum NDGLNavigationBarStyle {
    /// 흰색 배경
    case white
    /// 연한 회색 배경
    case gray
    
    var backgroundColor: UIColor {
        switch self {
        case .white:
            return DSKitAsset.Colors.white.color
        case .gray:
            return DSKitAsset.Colors.black50.color
        }
    }
}
