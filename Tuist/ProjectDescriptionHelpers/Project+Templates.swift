import ProjectDescription

private let rootPackagesName = "com.smartshop."

private func makeBundleID(with addition: String) -> String {
    (rootPackagesName + addition).lowercased()
}

public extension Target {
    static func makeApp(
        name: String,
        sources: SourceFilesList,
        dependencies: [TargetDependency]
    ) -> Target {
        Target.target(
            name: name,
            destinations: .iOS,
            product: .app,
            bundleId: makeBundleID(with: "app"),
            deploymentTargets: .iOS("16.0"),
            infoPlist: .extendingDefault(with: infoPlistExtension),
            sources: sources,
            dependencies: dependencies
        )
    }

    static func makeFramework(
        name: String,
        sources: SourceFilesList,
        dependencies: [TargetDependency] = [],
        resources: ResourceFileElements? = []
    ) -> Target {
        Target.target(
            name: name,
            destinations: .iOS,
            product: defaultPackageType,
            bundleId: makeBundleID(with: name + ".framework"),
            deploymentTargets: .iOS("16.0"),
            sources: sources,
            resources: resources,
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
            sources: ["Implementation/**"],
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
            sources: ["Interface/**"],
            dependencies: dependencies,
            resources: resources
        )
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
}