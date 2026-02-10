//
//  Project.swift
//  27th-App-Team-1-iOSManifests
//
//  Created by 최안용 on 1/14/26.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "HomeFeature",
    targets: [
        .makeFrameworkTarget(
            name: "HomeFeature",
            dependencies: [
                .Features.baseFeatureDependency,
                .Features.Search.feature,
                .Features.Setting.feature                
            ],
            scripts: [.swiftLint],
            isStatic: true,
            hasResources: false
        )
    ]
)

