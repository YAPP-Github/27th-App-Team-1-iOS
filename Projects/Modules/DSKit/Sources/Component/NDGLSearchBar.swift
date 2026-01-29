//
//  NDGLSearchBar.swift
//  DSKit
//
//  Created by 최안용 on 1/27/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

/// NDGL 프로젝트에서 사용하는 검색바 포함 내비게이션 바입니다.
///
/// 좌측 버튼(뒤로가기 등), 중앙 검색 필드, 그리고 검색 필드 내부에 위치한 우측 버튼(검색 아이콘 등)으로 구성되어 있습니다.
/// `searchContainerView`는 높이에 맞게 캡슐 모양의 곡률이 자동 적용됩니다.
///
/// ### Example
/// ```swift
/// let searchBar = NDGLSearchBar(
///     placeholder: "검색어를 입력해주세요",
///     DSKitAsset.Assets.icBack.image,
///     DSKitAsset.Assets.icSearch.image
/// )
///
/// // 검색어 실시간 바인딩
/// searchBar.searchText
///     .bind(to: viewModel.input.searchQuery)
///     .disposed(by: disposeBag)
///
/// // 뒤로가기 액션
/// searchBar.leadingButtonDidTap
///     .subscribe(onNext: { [weak self] in
///         self?.navigationController?.popViewController(animated: true)
///     })
///     .disposed(by: disposeBag)
/// ```
public final class NDGLSearchBar: UIView {
    // MARK: - UI Components
    
    private let leadingButton = UIButton()
    private let trailingButton = UIButton()
    private let textField = UITextField()
    private let searchContainerView = UIView()
    private let containerStackView = UIStackView()

    // MARK: - Rx Events
    
    /// 좌측 버튼 탭 (주로 뒤로가기)
    public var leadingButtonDidTap: Observable<Void> {
        leadingButton.rx.tap.asObservable()
    }
    
    /// 우측 버튼 탭 (검색 실행 등)
    public var trailingButtonDidTap: Observable<Void> {
        trailingButton.rx.tap.asObservable()
    }
    
    /// 텍스트 변경 이벤트
    public var searchText: ControlProperty<String?> {
        textField.rx.text
    }
    
    // MARK: - Initializer
    
    /// NDGLSearchBar를 초기화합니다.
    /// - Parameters:
    ///   - placeholder: 검색창에 표시될  placeholder
    ///   - leadingIcon: 좌측 영역에 표시될 이미지
    ///   - trailingIcon: 검색 필드 우측 내부에 표시될 이미지
    public init(
        placeholder: String,
        _ leadingIcon: UIImage,
        _ trailingIcon: UIImage
    ) {
        super.init(frame: .zero)
        
        setStyle(placeholder, leadingIcon, trailingIcon)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extension

private extension NDGLSearchBar {
    func setStyle(_ placeholder: String, _ leading: UIImage, _ trailing: UIImage) {
        searchContainerView.do {
            $0.backgroundColor = DSKitAsset.Colors.black100.color
            $0.layer.cornerRadius = 22.adjustedH
            $0.clipsToBounds = true
        }
        
        textField.do {
            var placeHolderAttributes = UIFont.NDGL.bodyLR.attributes
            placeHolderAttributes[.foregroundColor] = DSKitAsset.Colors.black400.color
            $0.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: placeHolderAttributes
            )

            $0.font = UIFont.NDGL.bodyLR.font
            $0.textColor = DSKitAsset.Colors.black700.color
            $0.tintColor = DSKitAsset.Colors.black400.color
        
            $0.autocapitalizationType = .none
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
            $0.returnKeyType = .search
        }
        
        let normalColor = DSKitAsset.Colors.black600.color
        [(leadingButton, leading), (trailingButton, trailing)].forEach { button, image in
            var config = UIButton.Configuration.plain()
            config.image = image.resize(targetSize: 28.adjustedH).withRenderingMode(.alwaysTemplate)
            config.baseForegroundColor = normalColor
            button.configuration = config
        }
        
        containerStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.alignment = .center
        }
    }
    
    func setUI() {
        searchContainerView.addSubviews(textField, trailingButton)
        containerStackView.addArrangedSubviews(leadingButton, searchContainerView)
        addSubview(containerStackView)
    }
    
    func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(48.adjustedH)
        }
        
        containerStackView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
            $0.directionalVerticalEdges.equalToSuperview().inset(2)
        }
        
        leadingButton.snp.makeConstraints {
            $0.size.equalTo(40.adjustedH)
        }
        
        searchContainerView.snp.makeConstraints {
            $0.height.equalTo(44.adjustedH)
        }
        
        textField.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(18)
            $0.trailing.equalTo(trailingButton.snp.leading).offset(-2)
            $0.centerY.equalToSuperview()
        }
        
        trailingButton.snp.makeConstraints {
            $0.size.equalTo(40.adjustedH)
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }
}
