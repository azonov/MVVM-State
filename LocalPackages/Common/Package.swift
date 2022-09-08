// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Common",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "Common",
            targets: ["Common"]),
    ],
    targets: [
        .target(
            name: "Common",
            dependencies: [])
    ]
)
