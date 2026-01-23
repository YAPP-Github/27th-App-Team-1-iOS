//
//  Project.swift
//  FollowFeature
//
//  Created by kimnahun on 2026-01-23.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "FollowFeature",
    targets: [
        .makeFrameworkTarget(
            name: "FollowFeature",
            dependencies: [
                .Features.baseFeatureDependency
            ],
            scripts: [.swiftLint],
            isStatic: true,
            hasResources: false
        )
    ]
)
