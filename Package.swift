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
    .library(name: "SablePulse", targets: ["SablePulse"]),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "Sable",
      dependencies: ["SablePulse"],
      path: "Sable"
    ),

    // SableFoundation
    .target(name: "SableFoundation", path: "SableFoundation/Source"),
    .testTarget(
      name: "SableFoundationTests", dependencies: ["SableFoundation"], path: "SableFoundation/Tests"
    ),
    
    // SablePulse
    .target(
      name: "SablePulse",
      dependencies: ["SableFoundation"],
      path: "SablePulse/Source"
    ),
    .testTarget(name: "SablePulseTests", dependencies: ["SablePulse"], path: "SablePulse/Tests"),
  ]
)
