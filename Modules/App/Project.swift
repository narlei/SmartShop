import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: Feature.App.rawValue,
    targets: [
        .makeApp(
            name: "SmartShop",
            sources: [
                "Core"
            ],
            dependencies: [
                .interface(.Home),
                .implementation(.Home),
                .interface(.Networking),
                .implementation(.Networking)
            ]
        )
    ]
)
