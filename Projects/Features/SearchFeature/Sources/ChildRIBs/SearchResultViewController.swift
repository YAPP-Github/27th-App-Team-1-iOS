//
//  SearchResultViewController.swift
//  SearchFeature
//
//  Created by 최안용 on 2/18/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import UIKit

import DSKit

import RIBs
import RxSwift

protocol SearchResultPresentableListener: AnyObject {
    func detachSearchResult()
    func searchBtnTapped()
    func itemSelected(item: SearchResultItem)
    func reloadBtnTapped()
}

final class SearchResultViewController: UIViewController, SearchResultViewControllable {
    weak var listener: SearchResultPresentableListener?
    
    private let disposeBag = DisposeBag()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private let networkErrorView = NDGLErrorView()
    private let emptyView = EmptyView()
    private var dataSource: UICollectionViewDiffableDataSource<SearchResultSectionKind, SearchResultItem>! = nil
    
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
            listener?.detachSearchResult()
        }
    }
}

private extension SearchResultViewController {
    func setStyle() {
        view.backgroundColor = DSKitAsset.Colors.white.color
        
        collectionView.do {
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .clear
            $0.isScrollEnabled = true
            $0.contentInset = .init(top: 18.adjustedH, left: 0, bottom: 0, right: 0)
        }
        
        loadingIndicator.do {
            $0.color = DSKitAsset.Colors.green300.color
        }
        
        networkErrorView.do {
            $0.isHidden = true
        }
        
        emptyView.do {
            $0.isHidden = true
            $0.changeType(.noResults)
        }
    }
    
    func setUI() {
        view.addSubviews(collectionView, loadingIndicator, networkErrorView, emptyView)
    }
    
    func setLayout() {
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        networkErrorView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16.adjustedH)
        }
        
        emptyView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setCollectionView() {
        collectionView.do {
            $0.register(
                PopularInfoCell.self,
                forCellWithReuseIdentifier: PopularInfoCell.cellIdentifier
            )
            
            $0.register(
                SearchResultHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: SearchResultHeaderView.reusableViewIdentifier
            )
        }
    }
}

private extension SearchResultViewController {
    func applySnapShot(_ items: [SearchResultPresentationModel.ResultTrip]) {
        var snapshot = NSDiffableDataSourceSnapshot<SearchResultSectionKind, SearchResultItem>()
        
        
        snapshot.appendSections([.resultTrip])
        let resultItems = items.map { SearchResultItem.resultTrip($0) }
        snapshot.appendItems(resultItems, toSection: .resultTrip)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func setDataSource() {
        let resultTripRegistration = createResultTripCellRegistration()
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case .resultTrip(let tripList):
                return collectionView.dequeueConfiguredReusableCell(
                    using: resultTripRegistration,
                    for: indexPath,
                    item: tripList
                )
            }
        }
        
        configureSupplementaryView()
    }
    
    func configureSupplementaryView() {
        let headerRegistration = createHeaderRegistration(dataSource: dataSource)
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard SearchResultSectionKind(rawValue: indexPath.section) != nil else {
                return UICollectionReusableView()
            }
            
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
        collectionView.rx.itemSelected
            .compactMap { [weak self] indexPath in
                self?.dataSource.itemIdentifier(for: indexPath)
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
}

extension SearchResultViewController: SearchResultPresentable {
    func update(with model: SearchResultPresentationModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.applySnapShot(model.resultTrip)
            
            let isEmpty = model.resultTrip.isEmpty
            
            self.emptyView.isHidden = !isEmpty
            self.collectionView.isHidden = isEmpty
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
        }
    }
}
