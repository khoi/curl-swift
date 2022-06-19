// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "curl-swift",
    platforms: [
        .macOS(.v10_10)
    ],
    products: [
        .library(
            name: "curl-swift",
            targets: ["curl-swift"]
        )
    ],
    dependencies: [],
    targets: [
        .systemLibrary(
            name: "CCurl",
            path: "Sources/CCurl",
            providers: [
                .brew(["curl"]),
                .apt(["libcurl4-openssl-dev"]),
            ]
        ),
        .target(
            name: "curl-swift",
            dependencies: [
                "CCurl"
            ]
        ),
        .testTarget(name: "curl-swift-tests", dependencies: ["curl-swift"]),
    ]
)
