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
    func search(keyword: String)
    func detachSearchResult()
    func detachSearch()
}

final class SearchViewController: UIViewController, SearchPresentable, SearchViewControllable {
    weak var listener: SearchPresentableListener?
    
    private let searchBar = NDGLSearchBar(
        placeholder: "검색어를 입력하세요",
        DSKitAsset.Assets.icChevronLeft3.image,
        DSKitAsset.Assets.icSearch2.image
    )
        
    private let contentNavigationController = UINavigationController()
    private let emptyView = EmptyView()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboard()
        setStyle()
        setUI()
        setContentNavigation()
        setLayout()
        searchBar.focus()
        bindKeyboard()
        setupActions()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isMovingFromParent {
            contentNavigationController.interactivePopGestureRecognizer?.delegate = nil
            listener?.detachSearch()
        }
    }
    
    func pushChild(_ viewControllable: ViewControllable) {
        contentNavigationController.pushViewController(
            viewControllable.uiviewController,
            animated: true
        )
    }
    
    func popChild(_ animated: Bool) {
        contentNavigationController.popViewController(animated: animated)
    }
}

private extension SearchViewController {
    func setStyle() {
        view.backgroundColor = DSKitAsset.Colors.white.color
        
        contentNavigationController.do {
            $0.isNavigationBarHidden = true
            $0.view.backgroundColor = .clear
        }
    }
    
    func setUI() {
        view.addSubviews(searchBar)
    }
    
    func setLayout() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalToSuperview()
        }
        
        contentNavigationController.view.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
        }
    }
    
    func setContentNavigation() {
        let rootVC = UIViewController()
        rootVC.view.backgroundColor = DSKitAsset.Colors.white.color
        rootVC.view.addSubview(emptyView)
        emptyView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        contentNavigationController.setViewControllers([rootVC], animated: false)

        addChild(contentNavigationController)
        view.addSubview(contentNavigationController.view)
        contentNavigationController.didMove(toParent: self)

        contentNavigationController.interactivePopGestureRecognizer?.delegate = self
    }
    
    func bindKeyboard() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .subscribe(onNext: { [weak self] notification in
                guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
                let keyboardHeight = keyboardFrame.cgRectValue.height
                
                self?.contentNavigationController.view.snp.updateConstraints {
                    $0.bottom.equalToSuperview().inset(keyboardHeight)
                }
                
                UIView.animate(withDuration: 0.3) {
                    self?.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .subscribe(onNext: { [weak self] _ in
                self?.contentNavigationController.view.snp.updateConstraints {
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
                if owner.contentNavigationController.viewControllers.count > 1 {
                    owner.contentNavigationController.popViewController(animated: true)
                } else {
                    owner.listener?.detachSearch()
                }
            }
            .disposed(by: disposeBag)
        
        searchBar.searchButtonClicked
            .withLatestFrom(searchBar.searchText)
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .subscribe(with: self) { owner, text in
                owner.listener?.search(keyword: text)
            }
            .disposed(by: disposeBag)
        
        searchBar.trailingButtonDidTap
            .withLatestFrom(searchBar.searchText)
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .subscribe(with: self) { owner, text in
                owner.listener?.search(keyword: text)
            }
            .disposed(by: disposeBag)
        
        searchBar.editingDidBegin
            .subscribe(with: self) { owner, _ in
                if owner.contentNavigationController.viewControllers.count > 1 {
                    owner.contentNavigationController.popViewController(animated: false)
                }
            }
            .disposed(by: disposeBag)
    }
}

extension SearchViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer == contentNavigationController.interactivePopGestureRecognizer
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == contentNavigationController.interactivePopGestureRecognizer {
            return contentNavigationController.viewControllers.count > 1
        }
        return true
    }
}
