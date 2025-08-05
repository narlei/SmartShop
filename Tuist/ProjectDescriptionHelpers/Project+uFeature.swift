import ProjectDescription

public extension ProjectDescription.TargetDependency {
    private static func feature(target: String, featureName: String) -> ProjectDescription.TargetDependency {
        .project(target: target, path: .relativeToRoot("Modules/u" + featureName))
    }

    private static func feature(interface moduleName: String) -> ProjectDescription.TargetDependency {
        .feature(target: moduleName + "Interface", featureName: moduleName)
    }

    private static func feature(implementation moduleName: String) -> ProjectDescription.TargetDependency {
        .feature(target: moduleName, featureName: moduleName)
    }

    static func feature(interface moduleName: Feature) -> ProjectDescription.TargetDependency {
        .feature(interface: moduleName.rawValue)
    }

    static func feature(implementation moduleName: Feature) -> ProjectDescription.TargetDependency {
        .feature(implementation: moduleName.rawValue)
    }

    static func external(_ module: External) -> ProjectDescription.TargetDependency {
        .external(name: module.rawValue)
    }
}
