// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DeezerPlaylistSync",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/vapor/console.git", from: "3.1.1"),
        .package(url: "https://github.com/httpswift/swifter.git", .upToNextMajor(from: "1.4.7")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "DeezerPlaylistSync",
            dependencies: ["Console", "Command", "Swifter"]
        ),
        .testTarget(
            name: "DeezerPlaylistSyncTests",
            dependencies: ["DeezerPlaylistSync"]
        ),
    ]
)