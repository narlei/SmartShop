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
                .feature(interface: .Network),
                .feature(interface: .Home),
            ]
        )
    ]
)
