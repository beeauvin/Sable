// swift-tools-version:6.0

import PackageDescription

let package = Package(
  name: "Sable",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v13),
    .tvOS(.v13),
    .visionOS(.v1),
    .watchOS(.v6),
  ],
  products: [
    .library(name: "Sable", targets: ["Sable"])
  ],
  dependencies: [
    .package(url: "https://github.com/beeauvin/Obsidian.git", exact: "0.2.1")
  ],
  targets: [
    .target(name: "Sable", dependencies: ["Obsidian"], path: "Sources"),
    .testTarget(name: "SableTests", dependencies: ["Sable", "Obsidian"], path: "Tests")
  ]
)
