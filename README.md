# swift-rfc-6891

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

The EDNS(0) OPT pseudo-record and DNS message extensions of RFC 6891.

## Standard Reference

- **RFC**: 6891
- **Title**: Extension Mechanisms for DNS (EDNS(0))

## Installation

Add the package to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/swift-ietf/swift-rfc-6891.git", from: "0.0.1")
]
```

Add the product to a target that needs it:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "RFC 6891", package: "swift-rfc-6891")
    ]
)
```

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
