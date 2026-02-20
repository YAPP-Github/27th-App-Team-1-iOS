//
//  HomeViewController.swift
//  HomeFeature
//
//  Created by kimnahun on 2026-01-21.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import Domain
import DSKit

import RIBs
import RxCocoa
import RxSwift

// MARK: - HomePresentableListener

protocol HomePresentableListener: AnyObject {
    func searchBtnTapped()
    func settingBtnTapped()
    func itemSelected(item: HomeItem)
    func moreBtnTapped()
    func reloadBtnTapped()
}

// MARK: - HomeViewController

final class HomeViewController: UIViewController, HomeViewControllable {
    // MARK: - Properties
    weak var listener: HomePresentableListener?
    
    private let disposeBag = DisposeBag()
    let moreButtonTapped = PublishSubject<Void>()
    
    // MARK: - UI Components    
    private let navigationBar = NDGLNavigationBar(
        style: .white,
        trailingIcon: DSKitAsset.Assets.icSearch2.image,
        trailing2Icon: DSKitAsset.Assets.icSettings1.image
    )
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private let networkErrorView = NDGLErrorView()
    
    private var dataSource: UICollectionViewDiffableDataSource<HomeSectionKind, HomeItem>! = nil
    
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

// MARK: - UI Setup

private extension HomeViewController {
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-68.adjustedH)
        }
    }
    
    func setCollectionView() {
        collectionView.do {
            $0.register(
                PopularInfoCell.self,
                forCellWithReuseIdentifier: PopularInfoCell.cellIdentifier
            )
            $0.register(
                CategoryChipCell.self,
                forCellWithReuseIdentifier: CategoryChipCell.cellIdentifier
            )
            $0.register(
                HomeBannerCell.self,
                forCellWithReuseIdentifier: HomeBannerCell.cellIdentifier
            )
            $0.register(
                RecommendInfoCell.self,
                forCellWithReuseIdentifier: RecommendInfoCell.cellIdentifier
            )
            $0.register(
                HomeHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: HomeHeaderView.reusableViewIdentifier
            )
            $0.register(
                HomeFooterButtonView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: HomeFooterButtonView.reusableViewIdentifier
            )
        }
    }
}

// MARK: - Bind
private extension HomeViewController {
    func bindInteractor() {
        navigationBar.trailingButtonDidTap
            .subscribe(with: self) { owner, _ in
                owner.listener?.searchBtnTapped()
            }
            .disposed(by: disposeBag)
        
        navigationBar.trailing2ButtonDidTap
            .subscribe(with: self) { owner, _ in
                owner.listener?.settingBtnTapped()
            }
            .disposed(by: disposeBag)
        
        moreButtonTapped
            .subscribe(with: self) { owner, _ in
                owner.listener?.moreBtnTapped()
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
    
    func applySnapshot(with sections: [HomeSectionModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<HomeSectionKind, HomeItem>()
        sections.forEach {
            snapshot.appendSections([$0.section])
            snapshot.appendItems($0.items, toSection: $0.section)
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

private extension HomeViewController {
    func setDataSource() {
        let bannerRegistration = createBannerCellRegistration()
        let categoryRegistration = createCategoryCellRegistration()
        let popularTripRegistration = createPopularTripCellRegistration()
        let recommendedTripRegistration = createRecommedTripCellRegistration()
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case .banner(let banner):
                return collectionView.dequeueConfiguredReusableCell(
                    using: bannerRegistration,
                    for: indexPath,
                    item: banner
                )
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
            case .recommendedTrip(let tripList):
                return collectionView.dequeueConfiguredReusableCell(
                    using: recommendedTripRegistration,
                    for: indexPath,
                    item: tripList
                )
            }
        }
        
        configureSupplementaryView()
    }
    
    func configureSupplementaryView() {
        let headerRegistration = createHeaderRegistration()
        let popularFooterRegistration = createPopularFooterRegistration()
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard HomeSectionKind(rawValue: indexPath.section) != nil else {
                return UICollectionReusableView()
            }
            
            if kind == UICollectionView.elementKindSectionHeader {
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: headerRegistration,
                    for: indexPath
                )
            }
            
            if kind == UICollectionView.elementKindSectionFooter {
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: popularFooterRegistration,
                    for: indexPath
                )
            }
            
            return nil
        }
    }
}

extension HomeViewController: HomePresentable {
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
    
    func update(with sections: [HomeSectionModel]) {
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
}
