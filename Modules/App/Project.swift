import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: Feature.App.rawValue,
    targets: [
        .makeApp(
            name: "SmartShop",
            sources: [
                "Core/**"
            ],
            dependencies: [
                .feature(implementation: .Home),
                .feature(interface: .Home),
                .feature(interface: .Networking)
            ]
        )
    ]
)
