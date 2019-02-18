// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "NetTime",
    products: [
        .library(
            name: "NetTime",
            targets: ["NetTime"]),
    ],
    targets: [
        .target(
            name: "NetTime",
            dependencies: []),
        .testTarget(
            name: "NetTimeTests",
            dependencies: ["NetTime"]),
    ]
)
