//
//  SettingBuilder.swift
//  SettingFeature
//
//  Created by 최안용 on 2/9/26.
//  Copyright © 2026 NDGL-iOS. All rights reserved.
//

import RIBs

public protocol SettingDependency: Dependency {

}

final class SettingComponent: Component<SettingDependency> {

}

public protocol SettingBuildable: Buildable {
    func build(withListener listener: SettingListener) -> SettingRouting
}

public final class SettingBuilder: Builder<SettingDependency>, SettingBuildable {

    override public init(dependency: SettingDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: SettingListener) -> SettingRouting {
        let component = SettingComponent(dependency: dependency)
        let viewController = SettingViewController()
        let interactor = SettingInteractor(presenter: viewController)
        interactor.listener = listener
        return SettingRouter(interactor: interactor, viewController: viewController)
    }
}
