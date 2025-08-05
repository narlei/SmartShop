import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: Feature.Networking.rawValue,
    targets: [
        .feature(
            interface: .Networking,
            dependencies: [
            ]
        ),
        .feature(
            implementation: .Networking,
            dependencies: [
                .feature(interface: .Networking),
            ]
        )
    ]
)
