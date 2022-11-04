// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "DispatchTimer",
    platforms: [
        .macOS(.v11), .iOS(.v14), .tvOS(.v14), .watchOS(.v7),
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
            from: "4.0.0"
        ),
    ],
    targets: [
        .target(
            name: "DispatchTimer",
            dependencies: [
                .product(name: "Synchronized", package: "synchronized"),
            ]
        ),
        .testTarget(
            name: "DispatchTimerTests",
            dependencies: ["DispatchTimer"]
        ),
    ]
)
