//
//  Project+MakeModule.swift
//  27th-App-Team-1-iOSManifests
//
//  Created by 최안용 on 1/13/26.
//

import ProjectDescription
import EnvPlugin
import ConfigPlugin

extension Project {
    public static func makeModule(
        name: String,
        organizationName: String = Environment.organizationName,
        packages: [Package] = [],
        settings: Settings? = nil,
        targets: [Target] = [],
        schemes: [Scheme]? = nil,
        fileHeaderTemplate: FileHeaderTemplate? = nil,
        additionalFiles: [FileElement] = [],
        resourceSynthesizers: [ResourceSynthesizer] = .default
    ) -> Project {
        if let schemes = schemes {
            return Project(
                name: name,
                organizationName: organizationName,
                packages: packages,
                settings: .settings(configurations: XCConfig.prod),
                targets: targets,
                schemes: schemes,
                fileHeaderTemplate: fileHeaderTemplate,
                additionalFiles: additionalFiles,
                resourceSynthesizers: resourceSynthesizers
            )
        } else {
            return Project(
                name: name,
                organizationName: organizationName,
                packages: packages,
                settings: .settings(configurations: XCConfig.prod),
                targets: targets,
                fileHeaderTemplate: fileHeaderTemplate,
                additionalFiles: additionalFiles,
                resourceSynthesizers: resourceSynthesizers
            )
        }
    }
}
