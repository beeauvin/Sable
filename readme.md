# 🖤 Sable

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbeeauvin%2FSable%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/beeauvin/Sable)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbeeauvin%2FSable%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/beeauvin/Sable)
[![tests](https://github.com/beeauvin/Sable/actions/workflows/continuous-integration.yml/badge.svg)](https://github.com/beeauvin/Sable/actions/workflows/continuous-integration.yml)
[![codecov](https://codecov.io/gh/beeauvin/Sable/graph/badge.svg?token=tHGLyrd7rG)](https://codecov.io/gh/beeauvin/Sable)
[![Maintainability](https://qlty.sh/badges/746fd841-b456-4854-9560-4603ba3660fb/maintainability.svg)](https://qlty.sh/gh/beeauvin/projects/Sable)

🖤 Sable is a Swift 6+ utility library that prioritizes beautiful API design
with natural language interfaces, handling complexity internally while
presenting simplicity externally. Its only requirements are Swift 6+ and
Foundation, making it widely compatible across Swift environments.

At its core, Sable is a comprehensive reactive systems and application
framework. The initial release focuses on foundational utilities and
messaging components, with sophisticated reactive programming patterns
and architectural frameworks being refined for future releases.

## Philosophy & Vision

Sable began as a personal project born from practical needs during app
development. Its design choices reflect a belief that code can be both
functional and beautiful. That the composition of an API can **sing** to the
reader, similar to how well-crafted prose resonates beyond mere function.
Further, writing code should feel natural and expressive - APIs should help an
engineer's intent flow easily from their intention and vision.

Some choices, like the use of snake_case and natural language interfaces, stem
from accessibility needs that make code more readable and reduce cognitive load
for me; and potentially others with similar processing styles. Other choices
come from a desire to create APIs that flow naturally when read, making code
more approachable and self-documenting.

While Sable intentionally breaks from some Swift community conventions, these
departures aren't arbitrary. Each divergence serves a purpose: enhancing
readability, reducing cognitive load, or enabling more expressive code. Sable is
primarily built for my needs, but I'm sharing it because these approaches might
resonate with others too.

## Design Principles

### Natural Language APIs

Creating interfaces that read like English makes code intent clearer and reduces
cognitive load when reading. Methods like `otherwise` instead of the nil
coalescing operator (`??`) transform symbolic operations into readable
statements.

### Progressive Disclosure

Simple things should remain simple. Complexity is opt-in, revealed only when
needed. Basic use cases have straightforward APIs, while power users can access
advanced functionality through explicit opt-in.

### Goal-Oriented Design

Meeting design goals takes precedence over community conventions. When
established patterns conflict with readability or ergonomics, Sable prioritizes
the developer experience.

### Comprehensive Type Safety

Type safety isn't merely a goal but a fundamental principle. Sable avoids type
erasure entirely, maintaining strong compile-time type safety throughout. This
approach not only prevents runtime errors but enables compiler optimizations and
provides better tooling support.

### Modern Thread Safety

Built exclusively on Swift's actor system and structured concurrency model,
Sable contains no locks or older threading mechanisms. Every API is designed for
heavy actor-based, multi-threaded environments, with proper isolation and
communication patterns built-in from the ground up.

### Memory Safety

All APIs take memory safety seriously by design. When memory management can't be
completely hidden from users, the libraries provide clear guidance and tools to
ensure proper resource lifecycle management.

### Non-Throwing Code Design

Sable contains zero throwable functions, instead embracing the Result type and
proper error handling throughout. This design choice leads to more predictable
code paths and explicit error handling. The library also avoids exposing
functionality that would encourage throwable code in consumer applications.

### Intentional Specificity

Components and APIs are designed with clear, specific intents. This principle
guides the architecture toward precise, purposeful connections rather than
generic, catch-all solutions.

## Module Structure

Sable is organized as a Swift Package Manager project with a focused
architecture:

### Available Modules

- **Sable**: Umbrella module providing a unified import that re-exports all
  submodules except SableFoundation.
- [**SableFoundation**](./SableFoundation/readme.md): **DEPRECATED - USE
  [Obsidian](https://github.com/beeauvin/Obsidian) INSTEAD**! Core Swift extensions and
  utilities that enhance the standard library with natural language alternatives
- [**SablePulse**](./SablePulse/readme.md): Type-safe message primitives for building 
  event-based systems, providing immutable, strongly-typed message containers with rich metadata

### Future Modules

- **SableFlow**: Advanced reactive programming patterns for building responsive,
  resilient applications
- **SableWeave**: Architectural framework built on SableFlow for creating
  modular, testable applications

### Progressive Release & Stability

It's maybe worth noting that much of Sable's features and modules are in active
use. The challenge at the moment is that they have all been written as internal
to another project and need to be extracted and polished a little; things like
documenting them better. Until all modules are public this package will stay
pre-v1.0. That said, I do not expect any breaking changes and am hoping to get a
fairly consistent release cycle going.

A special callout to Foundation: I think a lot of it's utility functions are
powerful but I am not dramatically inspired to just release them by themselves.
As larger features that use them come out I will update Foundation accordingly.

## Getting Started

### Installation

Add Sable to your Swift package dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/beeauvin/Sable.git", from: "0.1.0")
]
```

### Basic Usage

Import the specific modules you need:

```swift
import SableFoundation  // Core extensions (also imports Foundation)
import SablePulse       // Event messaging system
import Sable            // Imports all Sable modules (except SableFoundation)
```

See individual module READMEs for detailed usage examples.

## License

🖤 Sable is available under the [Mozilla Public License 2.0](https://mozilla.org/MPL/2.0/).

A copy of the MPLv2 is included [license.md](/license.md) file for convenience.

## Contributing

While Sable is primarily developed for personal use, contributions are welcome.
I do not have a formal process for this in place at the moment but intend to
adopt the [Contributor Covenant](https://www.contributor-covenant.org) so those
standards are the expectation.

The key consideration for contributions is alignment with Sable's core
philosophy and design goals. Technical improvements, documentation, and testing
are all valuable areas for contribution.
