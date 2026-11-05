// swift-tools-version: 6.4

import PackageDescription

extension String {
    static let rfc6891: Self = "RFC 6891"
}

extension Target.Dependency {
    static var rfc6891: Self { .target(name: .rfc6891) }
    static var rfc1035: Self { .product(name: "RFC 1035", package: "swift-rfc-1035") }
    static var standards: Self { .product(name: "Standard Library Extensions", package: "swift-standard-library-extensions") }
    static var incits41986: Self { .product(name: "ASCII", package: "swift-ascii") }
    static var binary: Self { .product(name: "Binary", package: "swift-binary") }
}

let package = Package(
    name: "swift-rfc-6891",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27)
    ],
    products: [
        .library(name: "RFC 6891", targets: ["RFC 6891"])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-ietf/swift-rfc-1035.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-standard-library-extensions.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-ascii.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-binary.git", branch: "main", traits: ["Serializer"])
    ],
    targets: [
        .target(
            name: "RFC 6891",
            dependencies: [
                .rfc1035,
                .standards,
                .incits41986,
                .binary
            ]
        ),
        .testTarget(
            name: "RFC 6891 Tests",
            dependencies: [
                "RFC 6891",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

extension String {
    var tests: Self { self + " Tests" }
}

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
