// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MVVMExample",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "MVVMExample",
            targets: ["MVVMExample"]),
    ],
    dependencies: [
        .package(path: "LocalPackages/Common"),
        .package(path: "LocalPackages/DataModule")
    ],
    targets: [
        .target(
            name: "MVVMExample",
            dependencies: ["Common", "DataModule"]),
        .testTarget(
            name: "MVVMExampleTests",
            dependencies: ["MVVMExample"]),
    ]
)
