// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "PortfolioEmailMaker",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "PortfolioEmailMaker",
            targets: ["PortfolioEmailMaker"]
        ),
    ],
    targets: [
        .target(
            name: "PortfolioEmailMaker",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "PortfolioEmailMakerTests",
            dependencies: ["PortfolioEmailMaker"]
        ),
    ]
)