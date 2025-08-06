import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: Feature.Home.rawValue,
    targets: [
        .feature(
            interface: .Home
        ),
        .feature(
            implementation: .Home,
            dependencies: [
                .interface(.Networking),
                .interface(.Home)
            ]
        ),
        .test(
            implementation: .Home,
            dependencies: [
                .interface(.Home)
            ]
        )
    ]
)
