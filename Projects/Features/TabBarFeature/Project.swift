//
//  Project.swift
//  TabBarFeature
//
//  Created by kimnahun on 2026-01-22.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "TabBarFeature",
    targets: [
        .makeFrameworkTarget(
            name: "TabBarFeature",
            dependencies: [
                .Features.Home.feature,
                .Features.MyTravel.feature
                .Features.TravelTool.feature
            ],
            scripts: [.swiftLint],
            isStatic: true,
            hasResources: false
        )
    ]
)
