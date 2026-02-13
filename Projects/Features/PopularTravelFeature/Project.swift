//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 최안용 on 2026/02/12.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "PopularTravelFeature",
    targets: [
        .makeFrameworkTarget(
            name: "PopularTravelFeature",
            dependencies: [
                .Features.baseFeatureDependency
            ],
            scripts: [.swiftLint],
            isStatic: true,
            hasResources: false
        )
    ]
)
