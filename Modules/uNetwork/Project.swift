import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: Feature.Network.rawValue,
    targets: [
        .feature(
            interface: .Network,
            dependencies: [
            ]
        ),
        .feature(
            implementation: .Network,
            dependencies: [
                .feature(interface: .Network),
            ]
        )
    ]
)
