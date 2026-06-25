import ProjectDescription
import ProjectDescriptionHelpers

let sharedDeps: [TargetDependency] = [
    .project(target: "Domain",      path: "../Domain"),
    .project(target: "DesignSystem", path: "../DesignSystem"),
]

let project = Project(
    name: "Features",
    targets: [
        // MARK: FeatureExplore
        .feature(name: "FeatureExplore", deps: sharedDeps),
        .tests(for: "FeatureExplore", extraDeps: sharedDeps),

        // MARK: FeatureDetail
        .feature(name: "FeatureDetail", deps: sharedDeps),

        // MARK: FeaturePlan
        .feature(name: "FeaturePlan", deps: sharedDeps),
        .tests(for: "FeaturePlan", extraDeps: sharedDeps),

        // MARK: FeatureSummary
        .feature(name: "FeatureSummary", deps: sharedDeps),
    ]
)
