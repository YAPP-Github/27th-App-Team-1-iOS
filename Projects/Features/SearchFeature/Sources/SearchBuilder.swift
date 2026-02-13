//
//  SearchBuilder.swift
//  SearchFeature
//
//  Created by 최안용 on 2/7/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs

public protocol SearchDependency: Dependency {
    
}

final class SearchComponent: Component<SearchDependency> {
    
}

public protocol SearchBuildable: Buildable {
    func build(withListener listener: SearchListener) -> SearchRouting
}

public final class SearchBuilder: Builder<SearchDependency>, SearchBuildable {

    override public init(dependency: SearchDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: SearchListener) -> SearchRouting {
        let component = SearchComponent(dependency: dependency)
        let viewController = SearchViewController()
        let interactor = SearchInteractor(presenter: viewController)
        interactor.listener = listener
        
        return SearchRouter(interactor: interactor, viewController: viewController)
    }
}
