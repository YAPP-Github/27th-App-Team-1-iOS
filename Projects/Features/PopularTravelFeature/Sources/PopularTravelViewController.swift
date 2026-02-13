//
//  PopularTravelViewController.swift
//  PopularTravelFeature
//
//  Created by 최안용 on 2/12/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import DSKit

import RIBs
import RxCocoa
import RxSwift

protocol PopularTravelPresentableListener: AnyObject {
    func detachPopularTravel()
    func searchBtnTapped()
    func itemSelected(item: PopularTravelItem)
    func reloadBtnTapped()
}

final class PopularTravelViewController: UIViewController, PopularTravelViewControllable {

    weak var listener: PopularTravelPresentableListener?
    
    private let disposeBag = DisposeBag()
    
    private let navigationBar = NDGLNavigationBar(
        style: .white,
        title: "인기 여행 따라가기",
        leadingIcon: DSKitAsset.Assets.icChevronLeft3.image,
        trailingIcon: DSKitAsset.Assets.icSearch2.image
    )
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private let networkErrorView = NDGLErrorView()
    
    private var dataSource: UICollectionViewDiffableDataSource<PopularTravelSectionKind, PopularTravelItem>?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyle()
        setUI()
        setLayout()
        
        setCollectionView()
        setDataSource()
        bindInteractor()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isMovingFromParent {
            listener?.detachPopularTravel()
        }
    }
}

private extension PopularTravelViewController {
    func setStyle() {
        view.backgroundColor = DSKitAsset.Colors.white.color
        
        collectionView.do {
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .clear
            $0.contentInset = .zero
            $0.isScrollEnabled = true
        }
        
        loadingIndicator.do {
            $0.color = DSKitAsset.Colors.green300.color
        }
        
        networkErrorView.do {
            $0.isHidden = true
        }
    }
    
    func setUI() {
        view.addSubviews(collectionView, navigationBar, loadingIndicator, networkErrorView)
    }
    
    func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        networkErrorView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16.adjustedH)
        }
    }
    
    func setCollectionView() {
        collectionView.do {
            $0.register(
                CategoryChipCell.self,
                forCellWithReuseIdentifier: CategoryChipCell.cellIdentifier
            )
            
            $0.register(
                PopularInfoCell.self,
                forCellWithReuseIdentifier: PopularInfoCell.cellIdentifier
            )
        }
    }
}

private extension PopularTravelViewController {
    func bindInteractor() {
        navigationBar.leadingButtonDidTap
            .subscribe(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        navigationBar.trailingButtonDidTap
            .subscribe(with: self) { owner, _ in
                owner.listener?.searchBtnTapped()
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .compactMap { [weak self] indexPath in
                self?.dataSource?.itemIdentifier(for: indexPath)
            }
            .subscribe(with: self) { owner, item in
                owner.listener?.itemSelected(item: item)
            }
            .disposed(by: disposeBag)
        
        networkErrorView.buttonDidTap
            .subscribe(with: self) { owner, _ in
                owner.listener?.reloadBtnTapped()
            }
            .disposed(by: disposeBag)
    }
    
    func applySnapshot(with sections: [PopularTravelSectionModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<PopularTravelSectionKind, PopularTravelItem>()
        sections.forEach {
            snapshot.appendSections([$0.section])
            snapshot.appendItems($0.items, toSection: $0.section)
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func setDataSource() {
        let categoryRegistration = createCategoryCellRegistration()
        let popularTripRegistration = createPopularTripCellRegistration()
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case .category(let category):
                return collectionView.dequeueConfiguredReusableCell(
                    using: categoryRegistration,
                    for: indexPath,
                    item: category
                )
            case .popularTrip(let tripList):
                return collectionView.dequeueConfiguredReusableCell(
                    using: popularTripRegistration,
                    for: indexPath,
                    item: tripList
                )
            }
        }
    }
}

extension PopularTravelViewController: PopularTravelPresentable {
    func update(with sections: [PopularTravelSectionModel]) {
        DispatchQueue.main.async { [weak self] in
            self?.applySnapshot(with: sections)
        }
    }
    
    func setLoading(_ isLoading: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            if isLoading {
                self.loadingIndicator.startAnimating()
                self.collectionView.alpha = 0.5
            } else {
                self.loadingIndicator.stopAnimating()
                self.collectionView.alpha = 1.0
            }
        }
    }
    
    func showErrorView(_ isError: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.networkErrorView.isHidden = !isError
            
            self.collectionView.isHidden = isError
            if isError {
                self.loadingIndicator.stopAnimating()
            }
        }
    }
}
