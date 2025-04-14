// swift-tools-version:6.0

import PackageDescription

let package = Package(
  name: "Sable",
  platforms: [
    .macOS(.v15)
  ],
  products: [
    .library(name: "Sable", targets: ["Sable"]),
    .library(name: "SableFoundation", targets: ["SableFoundation"]),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "Sable",
      dependencies: [],
      path: "Sable"
    ),

    // SableFoundation
    .target(name: "SableFoundation", path: "SableFoundation/Source"),
    .testTarget(
      name: "SableFoundationTests", dependencies: ["SableFoundation"], path: "SableFoundation/Tests"
    ),
  ]
)
