// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings
    
    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,]
        productTypes: [
            "RxSwift": .framework,
            "RxCocoa": .framework,
            "RxRelay": .framework,
            "RxCocoaRuntime": .framework,
            "Moya": .framework,
            "Alamofire": .framework,
            "SnapKit": .framework,
            "Then": .framework,
            "Kingfisher": .framework,
            "RIBs": .framework
        ]
    )
#endif

let package = Package(
    name: "NDGL-iOS",
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", from: "15.0.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.0.1"),
        .package(url: "https://github.com/devxoul/Then", from: "2.0.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.0.0"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "8.0.0"),
        .package(url: "https://github.com/uber/RIBs-iOS.git", from: "1.0.0")
    ]
)

