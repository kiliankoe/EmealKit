// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "EmealKit",
    platforms: [
        .macOS(.v11),
        .iOS(.v15),
        .watchOS(.v7),
        .tvOS(.v14),
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
