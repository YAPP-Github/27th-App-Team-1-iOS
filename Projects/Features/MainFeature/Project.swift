//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 최안용 on 2026/02/11.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "MainFeature",
    targets: [
        .makeFrameworkTarget(
            name: "MainFeature",
            dependencies: [
                .Features.baseFeatureDependency,
                .Features.Follow.feature,
                .Features.Search.feature,
                .Features.Setting.feature,
                .Features.TabBar.feature,
                .Features.PopularTravel.feature
            ],
            scripts: [.swiftLint],
            isStatic: true,
            hasResources: false
        )
    ]
)
