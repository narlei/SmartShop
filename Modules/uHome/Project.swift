import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: Feature.Home.rawValue,
    targets: [
        .feature(
            interface: .Home,
            dependencies: [
            ]
        ),
        .feature(
            implementation: .Home,
            dependencies: [
                .feature(interface: .Networking),
                .feature(interface: .Home)
            ]
        ),
        .test(
            implementation: .Home,
            dependencies: [
                .feature(interface: .Home)
            ]
        )
    ]
)
