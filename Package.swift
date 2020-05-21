// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "XpenseServer",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "XpenseServer", targets: ["XpenseServer"])
    ],
    dependencies: [
        .package(url: "https://github.com/Apodini/corvus.git", .branch("develop")),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.0.0-rc")
    ],
    targets: [
        .target(name: "Run",
                dependencies: [
                    .target(name: "XpenseServer")
                ]),
        .target(name: "XpenseServer",
                dependencies: [
                    .product(name: "Corvus", package: "corvus"),
                    .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver")
                ]),
        .testTarget(name: "XpenseServerTests",
                    dependencies: [
                        .target(name: "XpenseServer"),
                        .product(name: "XCTVapor", package: "vapor"),
                        .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver")
                    ])
    ]
)
