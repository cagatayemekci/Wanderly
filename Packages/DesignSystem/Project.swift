import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "DesignSystem",
    targets: [
        .plain(
            name: "DesignSystem",
            sourcesPath: "Sources/DesignSystem",
            deps: [.project(target: "Domain", path: "../Domain")]
        ),
    ]
)
