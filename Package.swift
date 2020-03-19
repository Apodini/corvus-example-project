// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "app",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .executable(name: "Run", targets: ["Run"]),
        .library(name: "App", targets: ["App"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(
            url: "https://github.com/Apodini/corvus",
            from: "0.0.6"
        ),

        .package(
            url: "https://github.com/vapor/fluent-sqlite-driver.git",
            from: "4.0.0-rc"
        ),
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                .product(name: "Corvus", package: "corvus"),
                .product(
                    name: "FluentSQLiteDriver",
                    package: "fluent-sqlite-driver"
                ),
            ]
        ),
        .target(name: "Run", dependencies: ["App"]),
    ]
)
