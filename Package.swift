// swift-tools-version:6.0

import PackageDescription

let package = Package(
  name: "Sable",
  platforms: [
    .macOS(.v14),
    .iOS(.v18),
    .tvOS(.v18),
    .visionOS(.v2),
    .watchOS(.v11),
  ],
  products: [
    .library(name: "Sable", targets: ["Sable"])
  ],
  dependencies: [
    .package(url: "https://github.com/beeauvin/Obsidian.git", exact: "0.1.0")
  ],
  targets: [
    .target(name: "Sable", dependencies: ["Obsidian"], path: "Sources"),
    .testTarget(name: "SableTests", dependencies: ["Sable", "Obsidian"], path: "Tests")
  ]
)
