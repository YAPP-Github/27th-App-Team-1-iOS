//
//  Project.swift
//  TravelToolFeature
//
//  Created by kimnahun on 2026-02-21.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "TravelToolFeature",
    targets: [
        .makeFrameworkTarget(
            name: "TravelToolFeature",
            dependencies: [
                .Features.baseFeatureDependency
            ],
            scripts: [.swiftLint],
            isStatic: true,
            hasResources: false
        )
    ]
)
