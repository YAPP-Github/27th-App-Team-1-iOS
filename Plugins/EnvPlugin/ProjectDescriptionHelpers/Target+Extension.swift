//
//  Target+Extension.swift
//  EnvPlugin
//
//  Created by 최안용 on 1/13/26.
//

import ProjectDescription

//MARK: - App Target 생성
public extension Target {
    static func makeAppTarget(
        name: String,
        deploymentTargetsVersion: String = Environment.App.version,
        infoPlist: [String : Plist.Value],
        entitlements: String? = nil,
        scripts: [TargetScript],
        dependencies: [TargetDependency],
        settings: Settings
    ) -> Target {
        let appTaget: Target = .target(
            name: name,
            destinations: [.iPhone],
            product: .app,
            bundleId: "\(Environment.bundleId).\(name)",
            deploymentTargets: .iOS(deploymentTargetsVersion),
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            entitlements: entitlements.map {
                .file(path: .relativeToRoot($0))
            },
            scripts: scripts,
            dependencies: dependencies,
            settings: settings
        )
        
        return appTaget
    }
}

//MARK: - Framework Target 생성
public extension Target {
    static func makeFrameworkTarget(
        name: String,
        infoPlist: [String : Plist.Value] = [:],
        sources: SourceFilesList = ["Sources/**"],
        dependencies: [TargetDependency],
        scripts: [TargetScript],
        isStatic: Bool = false,
        hasResources: Bool = true,
        settings: Settings? = nil
    ) -> Target {
        return .target(
            name: name,
            destinations: .iOS,
            product: isStatic ? .staticFramework : .framework,
            bundleId: "\(Environment.bundleId).\(name)",
            deploymentTargets: .iOS(Environment.deploymentTarget),
            infoPlist: .extendingDefault(with: infoPlist),
            sources: sources,
            resources: hasResources ? ["Resources/**"] : nil,
            scripts: scripts,
            dependencies: dependencies,
            settings: settings ?? .frameworkSettings
        )
    }
}
