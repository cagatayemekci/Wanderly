import ProjectDescription

public let bundleIdPrefix = "com.wanderly"
public let iOSDeploymentTarget = DeploymentTargets.iOS("17.0")

let baseSettings: SettingsDictionary = [
    "SWIFT_VERSION": "5.0",
]

let strictSettings: SettingsDictionary = [
    "SWIFT_VERSION": "5.0",
    "SWIFT_STRICT_CONCURRENCY": "complete",
]

public extension Target {
    // Bağımsız modül (Domain, Data, DesignSystem).
    static func plain(
        name: String,
        sourcesPath: String,
        resources: ResourceFileElements? = nil,
        deps: [TargetDependency] = [],
        strictConcurrency: Bool = false
    ) -> Target {
        .target(
            name: name,
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "\(bundleIdPrefix).\(name.lowercased())",
            deploymentTargets: iOSDeploymentTarget,
            sources: ["\(sourcesPath)/**"],
            resources: resources,
            dependencies: deps,
            settings: .settings(base: strictConcurrency ? strictSettings : baseSettings)
        )
    }

    // Feature modülü — kaynaklar Sources/<name>/ altında.
    static func feature(
        name: String,
        deps: [TargetDependency] = []
    ) -> Target {
        plain(name: name, sourcesPath: "Sources/\(name)", deps: deps)
    }

    // Unit test target — kaynaklar Tests/<name>Tests/ altında.
    static func tests(
        for targetName: String,
        extraDeps: [TargetDependency] = []
    ) -> Target {
        .target(
            name: "\(targetName)Tests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(bundleIdPrefix).\(targetName.lowercased())tests",
            deploymentTargets: iOSDeploymentTarget,
            sources: ["Tests/\(targetName)Tests/**"],
            dependencies: [.target(name: targetName)] + extraDeps
        )
    }
}
