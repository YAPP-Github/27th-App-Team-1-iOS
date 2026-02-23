//
//  MyTravelViewController.swift
//  MyTravelFeature
//
//  Created by 최안용 on 2/21/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import Domain
import DSKit

import RIBs
import RxCocoa
import RxSwift

protocol MyTravelPresentableListener: AnyObject {
    func viewWillAppear()
    func myTraveDidTapSearch()
    func itemSelected(item: MyTravelItem)
    func reloadBtnTapped()
    func myTraveDidTapPopularTravel()
}

final class MyTravelViewController: UIViewController, MyTravelViewControllable {

    weak var listener: MyTravelPresentableListener?
    
    private let disposeBag = DisposeBag()
    
    private let navigationBar = NDGLNavigationBar(
        style: .white,
        trailingIcon: DSKitAsset.Assets.icSearch2.image
    )
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private let networkErrorView = NDGLErrorView()
    
    var dataSource: UICollectionViewDiffableDataSource<MyTravelSectionKind, MyTravelItem>! = nil
    let newTravelBtnTapped = PublishSubject<Void>()
    
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
        listener?.viewWillAppear()
    }
}

private extension MyTravelViewController {
    func setStyle() {
        view.backgroundColor = DSKitAsset.Colors.white.color
        
        collectionView.do {
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .clear
            $0.contentInset = .zero
            $0.isScrollEnabled = true
            $0.contentInset = .init(top: 21.adjustedH, left: 0, bottom: 0, right: 0)
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
                MyTravelBannerCell.self,
                forCellWithReuseIdentifier: MyTravelBannerCell.cellIdentifier
            )
            
            $0.register(
                EmptyUpcomingCell.self,
                forCellWithReuseIdentifier: EmptyUpcomingCell.cellIdentifier
            )
            
            $0.register(
                UpcomingCell.self,
                forCellWithReuseIdentifier: UpcomingCell.cellIdentifier
            )
            
            $0.register(
                RecommendInfoCell.self,
                forCellWithReuseIdentifier: RecommendInfoCell.cellIdentifier
            )
            
            $0.register(
                MyTravelHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: MyTravelHeaderView.reusableViewIdentifier
            )
        }
    }
}

extension MyTravelViewController: MyTravelPresentable {
    func update(with sections: [(MyTravelSectionKind, [MyTravelItem])]) {
        DispatchQueue.main.async { [weak self] in
            guard let self, let dataSource = self.dataSource else { return }
            var snapshot = NSDiffableDataSourceSnapshot<MyTravelSectionKind, MyTravelItem>()
            
            sections.forEach { sectionKind, items in
                snapshot.appendSections([sectionKind])
                snapshot.appendItems(items, toSection: sectionKind)
            }
            
            self.dataSource.apply(snapshot, animatingDifferences: true)
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
            self.loadingIndicator.isHidden = !isLoading
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

private extension MyTravelViewController {
    func setDataSource() {
        let bannerReg = createBannerCellRegistration()
        let upcomingReg = createUpcomingCell()
        let recommendReg = createRecommedTripCellRegistration()
        
        let emptyReg = createEmptyUpcomingCellRegistration()
        
        dataSource = UICollectionViewDiffableDataSource<MyTravelSectionKind, MyTravelItem>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            switch item {
            case .banner(let banner):
                if banner.id == 0 {
                    return collectionView.dequeueConfiguredReusableCell(using: emptyReg, for: indexPath, item: banner)
                }
                return collectionView.dequeueConfiguredReusableCell(using: bannerReg, for: indexPath, item: banner)
                
            case .upcomingList(let upcoming):
                return collectionView.dequeueConfiguredReusableCell(using: upcomingReg, for: indexPath, item: upcoming)
                
            case .recommendTrip(let trip):
                return collectionView.dequeueConfiguredReusableCell(using: recommendReg, for: indexPath, item: trip)
            }
        }
        
        configureSupplementaryView()
    }
    
    func configureSupplementaryView() {
        let headerRegistration = createHeaderRegistration()
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader {
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: headerRegistration,
                    for: indexPath
                )
            }
            
            return nil
        }
    }
    
    func bindInteractor() {
        navigationBar.trailingButtonDidTap
            .subscribe(with: self) { owner, _ in
                owner.listener?.myTraveDidTapSearch()
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
        
        newTravelBtnTapped
            .subscribe(with: self) { owner, _ in
                owner.listener?.myTraveDidTapPopularTravel()
            }
            .disposed(by: disposeBag)
    }
}
