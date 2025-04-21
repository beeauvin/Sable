// swift-tools-version:6.0

import PackageDescription

let package = Package(
  name: "Sable",
  platforms: [
    .macOS(.v14),
  ],
  products: [
    .library(name: "Sable", targets: ["Sable"]),
    .library(name: "SablePulse", targets: ["SablePulse"]),
  ],
  dependencies: [
    .package(url: "https://github.com/beeauvin/Obsidian.git", exact: "0.1.0")
  ],
  targets: [
    .target(
      name: "Sable",
      dependencies: ["SablePulse"],
      path: "Sable"
    ),
    .testTarget(
      name: "SableTests",
      dependencies: ["Sable"],
      path: "Tests",
      exclude: ["readme.md"]
    ),
    
    // SablePulse
    .target(
      name: "SablePulse",
      dependencies: ["Obsidian"],
      path: "SablePulse/Source"
    ),
    .testTarget(name: "SablePulseTests", dependencies: ["SablePulse", "Obsidian"], path: "SablePulse/Tests"),
  ]
)
