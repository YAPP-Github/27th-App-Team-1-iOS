//
//  SearchResultBuilder.swift
//  SearchFeature
//
//  Created by 최안용 on 2/18/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import Domain

import RIBs

protocol SearchResultDependency: Dependency {
    var searchUsecase: TemplatesSearchUsecaseProtocol { get }
}

final class SearchResultComponent: Component<SearchResultDependency> {
    var searchUsecase: TemplatesSearchUsecaseProtocol {
        dependency.searchUsecase
    }
}

// MARK: - Builder

protocol SearchResultBuildable: Buildable {
    func build(withListener listener: SearchResultListener, searchKeyword: String) -> SearchResultRouting
}

final class SearchResultBuilder: Builder<SearchResultDependency>, SearchResultBuildable {
    

    override init(dependency: SearchResultDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SearchResultListener, searchKeyword: String) -> SearchResultRouting {
        let component = SearchResultComponent(dependency: dependency)
        let viewController = SearchResultViewController()
        let interactor = SearchResultInteractor(presenter: viewController, searchKeyword: searchKeyword, usecase: component.searchUsecase)
        interactor.listener = listener
        return SearchResultRouter(interactor: interactor, viewController: viewController)
    }
}
