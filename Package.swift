// swift-tools-version: 6.2

import PackageDescription

extension String {
    static let rfc6891: Self = "RFC 6891"
}

extension Target.Dependency {
    static var rfc6891: Self { .target(name: .rfc6891) }
    static var rfc1035: Self { .product(name: "RFC 1035", package: "swift-rfc-1035") }
    static var standards: Self { .product(name: "Standard Library Extensions", package: "swift-standard-library-extensions") }
    static var incits41986: Self { .product(name: "ASCII", package: "swift-ascii") }
}

let package = Package(
    name: "swift-rfc-6891",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(name: .rfc6891, targets: [.rfc6891])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-standards/swift-rfc-1035.git", from: "0.0.1"),
        .package(url: "https://github.com/swift-primitives/swift-standard-library-extensions.git", from: "0.0.1"),
        .package(url: "https://github.com/swift-foundations/swift-ascii.git", from: "0.0.1"),
    ],
    targets: [
        .target(
            name: .rfc6891,
            dependencies: [
                .rfc1035,
                .standards,
                .incits41986,
            ]
        ),
        .testTarget(
            name: .rfc6891.tests,
            dependencies: [
                .rfc6891
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

extension String {
    var tests: Self { self + " Tests" }
}

for target in package.targets where ![.system, .binary, .plugin].contains(target.type) {
    let existing = target.swiftSettings ?? []
    target.swiftSettings =
        existing + [
            .enableUpcomingFeature("ExistentialAny"),
            .enableUpcomingFeature("InternalImportsByDefault"),
            .enableUpcomingFeature("MemberImportVisibility"),
        ]
}
