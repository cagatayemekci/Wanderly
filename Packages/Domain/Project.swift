import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Domain",
    targets: [
        .plain(name: "Domain", sourcesPath: "Sources/Domain", strictConcurrency: true),
        .tests(for: "Domain"),
    ]
)
