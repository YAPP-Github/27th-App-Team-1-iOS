//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 최안용 on 2026/02/07.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "SearchFeature",
    targets: [
        .makeFrameworkTarget(
            name: "SearchFeature",
            dependencies: [
                .Features.baseFeatureDependency
            ],
            scripts: [.swiftLint],
            isStatic: true,
            hasResources: false
        )
    ]
)
