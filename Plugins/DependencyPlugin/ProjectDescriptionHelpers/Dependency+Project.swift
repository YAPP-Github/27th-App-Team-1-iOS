//
//  Dependency+Project.swift
//  EnvPlugin
//
//  Created by 최안용 on 1/13/26.
//

import ProjectDescription

public extension TargetDependency {
    struct Features {
        public struct Home {}
        public struct TabBar {}
        public struct Follow {}
    }

    struct Modules {}
}

public extension TargetDependency {
    static let data = TargetDependency.project(target: "Data", path: .data)
    static let domain = TargetDependency.project(target: "Domain", path: .domain)
    static let core = TargetDependency.project(target: "Core", path: .core)
}

public extension TargetDependency.Modules {
    static let dsKit = TargetDependency.project(target: "DSKit", path: .relativeToModules("DSKit"))
    static let networks = TargetDependency.project(target: "Networks", path: .relativeToModules("Networks"))
    static let thirdPartyLibs = TargetDependency.project(target: "ThirdPartyLibs", path: .relativeToModules("ThirdPartyLibs"))
}

public extension TargetDependency.Features {
    static func project(name: String, group: String) -> TargetDependency {
        .project(target: "\(group)\(name)", path: .relativeToFeature("\(group)\(name)"))
    }
    
    static let baseFeatureDependency = TargetDependency.project(target: "BaseFeatureDependency", path: .relativeToFeature("BaseFeatureDependency"))
    
    static let rootFeature = TargetDependency.project(target: "RootFeature", path: .relativeToFeature("RootFeature"))
}

public extension TargetDependency.Features.Home {
    static let group = "Home"

    static let feature = TargetDependency.Features.project(name: "Feature", group: group)
}

public extension TargetDependency.Features.TabBar {
    static let group = "TabBar"

    static let feature = TargetDependency.Features.project(name: "Feature", group: group)
}

public extension TargetDependency.Features.Follow {
    static let group = "Follow"

    static let feature = TargetDependency.Features.project(name: "Feature", group: group)
}
