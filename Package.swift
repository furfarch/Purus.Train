// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "purus.TRAIN",
    platforms: [
        .iOS(.v17),
        .watchOS(.v10)
    ],
    products: [
        .library(
            name: "purus.TRAIN",
            targets: ["purus.TRAIN"])
    ],
    targets: [
        .target(
            name: "purus.TRAIN",
            dependencies: [],
            path: "Sources"
        )
    ]
)
