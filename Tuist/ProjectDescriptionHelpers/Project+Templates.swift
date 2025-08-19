import ProjectDescription
import Foundation

private let rootPackagesName = "com.smartshop."

private func makeBundleID(with addition: String) -> String {
    (rootPackagesName + addition).lowercased()
}

public extension Target {
    static func makeApp(
        name: String,
        sources: [BuildableFolder],
        dependencies: [TargetDependency]
    ) -> Target {
        Target.target(
            name: name,
            destinations: .iOS,
            product: .app,
            bundleId: makeBundleID(with: "app"),
            deploymentTargets: .iOS("16.0"),
            infoPlist: .extendingDefault(with: infoPlistExtension),
            buildableFolders: sources,
            dependencies: dependencies
        )
    }

    static func makeFramework(
        name: String,
        sources: [BuildableFolder],
        dependencies: [TargetDependency] = [],
        resources: ResourceFileElements? = []
    ) -> Target {
        Target.target(
            name: name,
            destinations: .iOS,
            product: defaultPackageType,
            bundleId: makeBundleID(with: name + ".framework"),
            deploymentTargets: .iOS("16.0"),
            resources: resources,
            buildableFolders: sources,
            dependencies: dependencies
        )
    }

    private static func feature(
        implementation featureName: String,
        dependencies: [TargetDependency] = [],
        resources: ResourceFileElements? = []
    ) -> Target {
        makeFramework(
            name: featureName,
            sources: ["Implementation/Sources/"],
            dependencies: dependencies,
            resources: resources
        )
    }

    private static func feature(
        interface featureName: String,
        dependencies: [TargetDependency] = [],
        resources: ResourceFileElements? = []
    ) -> Target {
        makeFramework(
            name: featureName + "Interface",
            sources: ["Interface/Sources/"],
            dependencies: dependencies,
            resources: resources
        )
    }

    private static func test(
        name: String,
        basePath basePath: String,
        dependencies: [TargetDependency] = [],
        resources: ResourceFileElements? = []
    ) -> Target {
        let testDir = "\(basePath)/Tests/Sources"
        var allDependencies: [TargetDependency] = [.target(name: name)]
        allDependencies.append(contentsOf: dependencies)
        
        let testTarget = Target.target(
            name: "\(name)Tests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: makeBundleID(with: "\(name)Tests"),
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default,
            sources: ["\(basePath)/Tests/Sources/**"],
            dependencies: allDependencies
        )

        return testTarget
    }

    static func feature(
        implementation featureName: Feature,
        dependencies: [TargetDependency] = [],
        resources: ResourceFileElements? = []
    ) -> Target {
        .feature(
            implementation: featureName.rawValue,
            dependencies: dependencies,
            resources: resources
        )
    }

    static func feature(
        interface featureName: Feature,
        dependencies: [TargetDependency] = [],
        resources: ResourceFileElements? = []
    ) -> Target {
        .feature(
            interface: featureName.rawValue,
            dependencies: dependencies,
            resources: resources
        )
    }

    static func test(
        interface featureName: Feature,
        dependencies: [TargetDependency] = [],
        resources: ResourceFileElements? = []
    ) -> Target {
        .test(
            name: featureName.rawValue,
            basePath: "Interface",
            dependencies: dependencies,
            resources: resources
        )
    }

    static func test(
        implementation featureName: Feature,
        dependencies: [TargetDependency] = [],
        resources: ResourceFileElements? = []
    ) -> Target {
        .test(
            name: featureName.rawValue,
            basePath: "Implementation",
            dependencies: dependencies,
            resources: resources
        )
    }
}
