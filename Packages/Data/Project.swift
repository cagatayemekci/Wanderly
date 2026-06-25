import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Data",
    targets: [
        .plain(
            name: "Data",
            sourcesPath: "Sources/Data",
            resources: ["Resources/**"],
            deps: [.project(target: "Domain", path: "../Domain")],
            strictConcurrency: true
        ),
        .tests(
            for: "Data",
            extraDeps: [.project(target: "Domain", path: "../Domain")]
        ),
    ]
)
