//
//  Project.swift
//  27th-App-Team-1-iOSManifests
//
//  Created by 최안용 on 1/15/26.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "BaseFeatureDependency",
    targets: [
        .makeFrameworkTarget(
            name: "BaseFeatureDependency",
            dependencies: [
                .core,
                .domain,
                .Modules.dsKit,
                .SPM.RIBs,
                .SPM.Kingfisher
            ],
            scripts: [.swiftLint],
            hasResources: false
        )
    ]
)

