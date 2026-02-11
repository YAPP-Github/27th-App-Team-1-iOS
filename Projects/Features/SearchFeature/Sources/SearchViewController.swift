//
//  SearchViewController.swift
//  SearchFeature
//
//  Created by 최안용 on 2/7/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import DSKit

import RIBs
import RxSwift

protocol SearchPresentableListener: AnyObject {
    func detachSearch()
}

final class SearchViewController: UIViewController, SearchPresentable,  SearchViewControllable{
    weak var listener: SearchPresentableListener?
    
    private let searchBar = NDGLSearchBar(
        placeholder: "검색어를 입력하세요",
        DSKitAsset.Assets.icChevronLeft3.image,
        DSKitAsset.Assets.icSearch2.image
    )
    private let emptyImageView = UIImageView()
    private let titleLabel = UILabel()
    private let containerView = UIView()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        setStyle()
        setUI()
        setLayout()
        bindKeyboard()
        setupActions()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isMovingFromParent {
            listener?.detachSearch()
        }
    }
}

private extension SearchViewController {
    func setStyle() {
        emptyImageView.do {
            $0.image = DSKitAsset.Assets.icEmptySearch.image
            $0.contentMode = .scaleAspectFit
        }
        
        titleLabel.do {
            $0.setText(
                .bodyLM,
                text: "좋아하는 유튜버나 가고 싶은\n여행지를 검색해봐요",
                color: DSKitAsset.Colors.black400.color,
                alignment: .center
            )
            $0.numberOfLines = 2
        }
    }
    
    func setUI() {
        view.addSubviews(searchBar, containerView)
        containerView.addSubviews(emptyImageView, titleLabel)
    }
    
    func setLayout() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        emptyImageView.snp.makeConstraints {
            $0.width.equalTo(215.adjusted)
            $0.height.equalTo(198.adjustedH)
            $0.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
    }
    
    func bindKeyboard() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .subscribe(onNext: { [weak self] notification in
                guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
                let keyboardHeight = keyboardFrame.cgRectValue.height
                
                self?.containerView.snp.updateConstraints {
                    $0.bottom.equalToSuperview().inset(keyboardHeight)
                }
                
                UIView.animate(withDuration: 0.3) {
                    self?.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .subscribe(onNext: { [weak self] _ in
                self?.containerView.snp.updateConstraints {
                    $0.bottom.equalToSuperview()
                }
                
                UIView.animate(withDuration: 0.3) {
                    self?.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setupActions() {
        searchBar.leadingButtonDidTap
            .subscribe(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
