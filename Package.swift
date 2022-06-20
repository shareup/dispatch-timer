// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "DispatchTimer",
    platforms: [
        .macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v5),
    ],
    products: [
        .library(
            name: "DispatchTimer",
            targets: ["DispatchTimer"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/shareup/synchronized.git",
            from: "3.1.0"
        ),
    ],
    targets: [
        .target(
            name: "DispatchTimer",
            dependencies: [
                .product(name: "Synchronized", package: "synchronized"),
            ],
            swiftSettings: [
                .unsafeFlags([
                    "-Xfrontend", "-warn-concurrency",
                ]),
            ]
        ),
        .testTarget(
            name: "DispatchTimerTests",
            dependencies: ["DispatchTimer"]
        ),
    ]
)
