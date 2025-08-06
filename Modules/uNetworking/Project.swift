import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: Feature.Networking.rawValue,
    targets: [
        .feature(
            interface: .Networking
        ),
        .feature(
            implementation: .Networking,
            dependencies: [
                .interface(.Networking)
            ]
        )
    ]
)
