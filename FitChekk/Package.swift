// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FitChekk",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "FitChekk",
            targets: ["FitChekk"]
        )
    ],
    dependencies: [
        // The Composable Architecture
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            from: "1.15.0"
        ),
        // Supabase Swift SDK
        .package(
            url: "https://github.com/supabase/supabase-swift",
            from: "2.5.0"
        ),
        // Swift Dependencies (for TCA dependency management)
        .package(
            url: "https://github.com/pointfreeco/swift-dependencies",
            from: "1.0.0"
        )
    ],
    targets: [
        .target(
            name: "FitChekk",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Supabase", package: "supabase-swift"),
                .product(name: "Dependencies", package: "swift-dependencies")
            ],
            path: "FitChekk"
        ),
        .testTarget(
            name: "FitChekkTests",
            dependencies: ["FitChekk"],
            path: "FitChekkTests"
        )
    ]
)

