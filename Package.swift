// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "EmealKit",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v13),
    ],
    products: [
        .library(
            name: "EmealKit",
            targets: ["EmealKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/alexaubry/HTMLString.git", from: "5.0.0"),
        .package(url: "https://github.com/sharplet/Regex.git", from: "2.1.0"),
    ],
    targets: [
        .target(
            name: "EmealKit",
            dependencies: ["HTMLString", "Regex"]),
        .testTarget(
            name: "EmealKitTests",
            dependencies: ["EmealKit"]),
        .testTarget(
            name: "APIValidationTests",
            dependencies: ["EmealKit"]),
    ]
)
