// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "DispatchTimer",
    platforms: [
        .macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v5),
    ],
    products: [
        .library(
            name: "DispatchTimer",
            targets: ["DispatchTimer"]),
    ],
    dependencies: [
        .package(
            name: "Synchronized",
            url: "https://github.com/shareup/synchronized.git",
            from: "2.3.0"),
    ],
    targets: [
        .target(
            name: "DispatchTimer",
            dependencies: [
                .product(name: "SynchronizedDynamic", package: "Synchronized")
            ]),
        .testTarget(
            name: "DispatchTimerTests",
            dependencies: ["DispatchTimer"]),
    ]
)

