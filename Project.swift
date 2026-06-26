import ProjectDescription
import ProjectDescriptionHelpers

let appSettings: SettingsDictionary = [
    "SWIFT_VERSION": "5.0",
    "PRODUCT_BUNDLE_IDENTIFIER": "com.wanderly.app",
    "MARKETING_VERSION": "1.0.0",
    "CURRENT_PROJECT_VERSION": "1",
    "TARGETED_DEVICE_FAMILY": "1",
    "ENABLE_PREVIEWS": "YES",
    "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
    "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "AccentColor",
]

let swiftLintScript = TargetScript.pre(
    script: """
    export PATH="$PATH:/opt/homebrew/bin:/usr/local/bin"

    # Unset iOS SDK env vars so Mint/SPM can build tools for the macOS host
    unset SDKROOT PLATFORM_NAME ARCHS ONLY_ACTIVE_ARCH

    if command -v mint > /dev/null; then
        mint run swiftlint swiftlint --config "${SRCROOT}/.swiftlint.yml"
    elif command -v swiftlint > /dev/null; then
        swiftlint --config "${SRCROOT}/.swiftlint.yml"
    else
        echo "warning: SwiftLint not installed. Run: brew install mint && mint bootstrap"
    fi
    """,
    name: "SwiftLint",
    basedOnDependencyAnalysis: false
)

let project = Project(
    name: "Wanderly",
    organizationName: "Wanderly",
    targets: [
        .target(
            name: "Wanderly",
            destinations: .iOS,
            product: .app,
            bundleId: "com.wanderly.app",
            deploymentTargets: iOSDeploymentTarget,
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": .string("Wanderly"),
                "UILaunchScreen": .dictionary([:]),
                "UISupportedInterfaceOrientations": .array([.string("UIInterfaceOrientationPortrait")])
            ]),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            scripts: [swiftLintScript],
            dependencies: [
                .project(target: "Domain",         path: "Packages/Domain"),
                .project(target: "Data",            path: "Packages/Data"),
                .project(target: "DesignSystem",    path: "Packages/DesignSystem"),
                .project(target: "FeatureExplore",  path: "Packages/Features"),
                .project(target: "FeatureDetail",   path: "Packages/Features"),
                .project(target: "FeaturePlan",     path: "Packages/Features"),
                .project(target: "FeatureSummary",  path: "Packages/Features"),
            ],
            settings: .settings(base: appSettings)
        ),
        .target(
            name: "AppTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.wanderly.apptests",
            deploymentTargets: iOSDeploymentTarget,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "Wanderly"),
                .project(target: "Domain", path: "Packages/Domain"),
            ]
        ),
    ]
)
