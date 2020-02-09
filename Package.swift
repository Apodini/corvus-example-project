// swift-tools-version:5.1
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
            url: "https://github.com/bmikaili/corvus.git",
            from: "0.0.3"
        ),

        .package(
            url: "https://github.com/vapor/fluent-sqlite-driver.git",
            from: "4.0.0-beta.3"
        ),
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                "Corvus",
                "FluentSQLiteDriver",
            ]
        ),
        .target(name: "Run", dependencies: ["App"]),
    ]
)
