// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DataModule",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "DataModule",
            targets: ["DataModule"]),
    ],
    dependencies: [
         .package(path: "../Common")
    ],
    targets: [
        .target(
            name: "DataModule",
            dependencies: ["Common"]),
        .testTarget(
            name: "DataModuleTests",
            dependencies: ["DataModule"]),
    ]
)
