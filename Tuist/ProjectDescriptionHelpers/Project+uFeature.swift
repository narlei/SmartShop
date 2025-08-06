import ProjectDescription

public extension ProjectDescription.TargetDependency {
    private static func feature(target: String, featureName: String) -> ProjectDescription.TargetDependency {
        .project(target: target, path: .relativeToRoot("Modules/u" + featureName))
    }

    // MARK: - Taxonomy

    static func interface(_ moduleName: Feature) -> ProjectDescription.TargetDependency {
        .feature(target: moduleName.rawValue + "Interface", featureName: moduleName.rawValue)
    }

    static func implementation(_ moduleName: Feature) -> ProjectDescription.TargetDependency {
        .feature(target: moduleName.rawValue, featureName: moduleName.rawValue)
    }
}
