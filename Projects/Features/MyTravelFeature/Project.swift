//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 최안용 on 2026/02/21.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "MyTravelFeature",
    targets: [
        .makeFrameworkTarget(
            name: "MyTravelFeature",
            dependencies: [
                .Features.baseFeatureDependency
            ],
            scripts: [.swiftLint],
            isStatic: true,
            hasResources: false
        )
    ]
)
