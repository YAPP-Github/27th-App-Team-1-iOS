//
//  Project.swift
//  TravelFeature
//
//  Created by kimnahun on 2026-01-24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "TravelFeature",
    targets: [
        .makeFrameworkTarget(
            name: "TravelFeature",
            dependencies: [
                .Features.baseFeatureDependency
            ],
            scripts: [.swiftLint],
            isStatic: true,
            hasResources: false
        )
    ]
)
