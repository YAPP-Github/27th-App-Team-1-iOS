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
    func detachSearch()
    func itemSelected(item: SearchResultItem)
    func reloadBtnTapped()
}

final class SearchViewController: UIViewController, SearchPresentable, SearchViewControllable {
    weak var listener: SearchPresentableListener?

    private let searchBar = NDGLSearchBar(
        placeholder: "검색어를 입력하세요",
        DSKitAsset.Assets.icChevronLeft3.image,
        DSKitAsset.Assets.icSearch2.image
    )

    private let startEmptyView = EmptyView()
    private let noResultEmptyView = EmptyView()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private let networkErrorView = NDGLErrorView()
    private var dataSource: UICollectionViewDiffableDataSource<SearchResultSectionKind, SearchResultItem>!

    private let contentContainerView = UIView()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboard()
        setStyle()
        setUI()
        setLayout()
        setCollectionView()
        setDataSource()
        searchBar.focus()
        bindKeyboard()
        setupActions()
        bindInteractor()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if isMovingFromParent {
            listener?.detachSearch()
        }
    }
}

// MARK: - SearchPresentable

extension SearchViewController {
    func update(with model: SearchResultPresentationModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            self.applySnapShot(model.resultTrip)

            let isEmpty = model.resultTrip.isEmpty

            self.startEmptyView.isHidden = true
            self.noResultEmptyView.isHidden = !isEmpty
            self.collectionView.isHidden = isEmpty
        }
    }

    func setLoading(_ isLoading: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            if isLoading {
                self.startEmptyView.isHidden = true
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

private extension SearchViewController {
    func setStyle() {
        view.backgroundColor = DSKitAsset.Colors.white.color

        contentContainerView.do {
            $0.backgroundColor = .clear
        }

        collectionView.do {
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .clear
            $0.isScrollEnabled = true
            $0.contentInset = .init(top: 18.adjustedH, left: 0, bottom: 0, right: 0)
            $0.isHidden = true
        }

        loadingIndicator.do {
            $0.color = DSKitAsset.Colors.green300.color
        }

        networkErrorView.do {
            $0.isHidden = true
        }

        noResultEmptyView.do {
            $0.isHidden = true
            $0.changeType(.noResults)
        }

        startEmptyView.do {
            $0.changeType(.start)
        }
    }

    func setUI() {
        view.addSubviews(searchBar, contentContainerView)
        contentContainerView.addSubviews(startEmptyView, collectionView, loadingIndicator, networkErrorView, noResultEmptyView)
    }

    func setLayout() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalToSuperview()
        }

        contentContainerView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
        }

        startEmptyView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        networkErrorView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16.adjustedH)
        }

        noResultEmptyView.snp.makeConstraints {
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

    func bindKeyboard() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .subscribe(onNext: { [weak self] notification in
                guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
                let keyboardHeight = keyboardFrame.cgRectValue.height

                self?.contentContainerView.snp.updateConstraints {
                    $0.bottom.equalToSuperview().inset(keyboardHeight)
                }

                UIView.animate(withDuration: 0.3) {
                    self?.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .subscribe(onNext: { [weak self] _ in
                self?.contentContainerView.snp.updateConstraints {
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
                owner.listener?.detachSearch()
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
    }

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

// MARK: - CompositionalLayout

extension SearchViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let sectionKind = SearchResultSectionKind(rawValue: sectionIndex) else {
                return self?.emptyLayout()
            }

            switch sectionKind {
            case .resultTrip:
                return self?.createPopularTripSection()
            }
        }
    }

    private func createPopularTripSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(PopularInfoCell.defaultHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(PopularInfoCell.defaultHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16.adjustedH

        section.contentInsets = .init(
            top: 16.adjustedH,
            leading: 24.adjusted,
            bottom: 12.adjustedH,
            trailing: 24.adjusted
        )
        section.orthogonalScrollingBehavior = .none

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .estimated(43.adjusted),
            heightDimension: .absolute(30.adjustedH)
        )

        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )

        section.boundarySupplementaryItems = [header]

        return section
    }

    private func emptyLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let group = NSCollectionLayoutGroup(layoutSize: groupSize)

        let section = NSCollectionLayoutSection(group: group)

        return section
    }
}

// MARK: - Registration

extension SearchViewController {
    func createResultTripCellRegistration()
    -> UICollectionView.CellRegistration<PopularInfoCell, SearchResultPresentationModel.ResultTrip> {
        return UICollectionView.CellRegistration { cell, indexPath, item in
            cell.configure(
                thumbnailUrl: item.thumbnailUrl,
                city: item.city,
                title: item.title,
                nation: item.country,
                schedule: item.schedule
            )
        }
    }

    func createHeaderRegistration(
        dataSource: UICollectionViewDiffableDataSource<SearchResultSectionKind, SearchResultItem>
    ) -> UICollectionView.SupplementaryRegistration<SearchResultHeaderView> {
        return UICollectionView.SupplementaryRegistration<SearchResultHeaderView>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { [weak dataSource] headerView, elementKind, indexPath in
            guard let dataSource else { return }

            let snapshot = dataSource.snapshot()
            let itemCount = snapshot.numberOfItems(inSection: .resultTrip)

            headerView.configure(count: itemCount)
        }
    }
}
