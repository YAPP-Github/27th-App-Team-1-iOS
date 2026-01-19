//
//  Project.swift
//  27th-App-Team-1-iOSManifests
//
//  Created by 최안용 on 1/13/26.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "Data",
    targets: [
        .makeFrameworkTarget(
            name: "Data",
            dependencies: [
                .domain,
                .Modules.networks
            ],
            scripts: [.swiftLint],
            isStatic: true,
            hasResources: false
        )
    ]
)

