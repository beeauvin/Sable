# 🖤 Sable

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbeeauvin%2FSable%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/beeauvin/Sable)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbeeauvin%2FSable%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/beeauvin/Sable)
[![tests](https://github.com/beeauvin/Sable/actions/workflows/continuous-integration.yml/badge.svg)](https://github.com/beeauvin/Sable/actions/workflows/continuous-integration.yml)
[![codecov](https://codecov.io/gh/beeauvin/Sable/graph/badge.svg?token=tHGLyrd7rG)](https://codecov.io/gh/beeauvin/Sable)

🖤 Sable is a Swift 6+ framework that provides a comprehensive foundation for building reactive,
event-driven systems. It prioritizes beautiful API design with natural language interfaces, handling
complexity internally while presenting simplicity externally. Its only requirements are Swift 6+ and
Foundation, making it widely compatible across Swift environments.

At its core, Sable offers event messaging primitives along with reactive programming patterns for
creating resilient, responsive applications. The framework focuses on type safety, thread safety,
and expressive APIs that make your code both functional and beautiful.

## Philosophy & Vision

Sable began as a personal project born from practical needs during app development. Its design
choices reflect a belief that code can be both functional and beautiful. That the composition of an
API can **sing** to the reader, similar to how well-crafted prose resonates beyond mere function.
Further, writing code should feel natural and expressive - APIs should help an engineer's intent
flow easily from their intention and vision.

Some choices, like the use of snake_case and natural language interfaces, stem from accessibility
needs that make code more readable and reduce cognitive load for me; and potentially others with
similar processing styles. Other choices come from a desire to create APIs that flow naturally when
read, making code more approachable and self-documenting.

While Sable intentionally breaks from some Swift community conventions, these departures aren't
arbitrary. Each divergence serves a purpose: enhancing readability, reducing cognitive load, or
enabling more expressive code. Sable is primarily built for my needs, but I'm sharing it because
these approaches might resonate with others too.

## Design Principles

### Natural Language APIs

Creating interfaces that read like English makes code intent clearer and reduces cognitive load when
reading. Methods like `.echoes(original_pulse)` instead of more technical alternatives transform
functional code into readable statements that express intent clearly.

### Progressive Disclosure

Simple things should remain simple. Complexity is opt-in, revealed only when needed. Basic use cases
have straightforward APIs, while power users can access advanced functionality through explicit
opt-in.

### Goal-Oriented Design

Meeting design goals takes precedence over community conventions. When established patterns conflict
with readability or ergonomics, Sable prioritizes the developer experience.

### Comprehensive Type Safety

Type safety isn't merely a goal but a fundamental principle. Sable avoids type erasure entirely,
maintaining strong compile-time type safety throughout. This approach not only prevents runtime
errors but enables compiler optimizations and provides better tooling support.

### Modern Thread Safety

Built exclusively on Swift's actor system and structured concurrency model, Sable contains no locks
or older threading mechanisms. Every API is designed for heavy actor-based, multi-threaded
environments, with proper isolation and communication patterns built-in from the ground up.

### Memory Safety

All APIs take memory safety seriously by design. When memory management can't be completely hidden
from users, the libraries provide clear guidance and tools to ensure proper resource lifecycle
management.

### Non-Throwing Code Design

Sable contains zero throwable functions, instead embracing the Result type and proper error handling
throughout. This design choice leads to more predictable code paths and explicit error handling. The
library also avoids exposing functionality that would encourage throwable code in consumer
applications.

### Intentional Specificity

Components and APIs are designed with clear, specific intents. This principle guides the
architecture toward precise, purposeful connections rather than generic, catch-all solutions.

## Core Features

- **Type-Safe Messaging Primitives**: Full generic type support without any type erasure
- **Actor-Ready Value Types**: Designed specifically for Swift's actor system
- **Natural Language API**: Expressive, readable method names that form cohesive sentences
- **Immutable Message Design**: All operations produce new message instances
- **Comprehensive Metadata**: Rich operational context that travels with messages
- **Tracing & Causality**: Built-in support for tracing message flows and causality chains
- **Memory Safety**: Designed with proper resource lifecycle management
- **Debugging Support**: Debug-specific features to enhance visibility during development

### Type-Safe Messaging

Sable provides immutable, strongly-typed message primitives called "pulses" that can safely traverse
actor boundaries:

```swift
// Create a strongly-typed event message
let login_event = UserLoggedIn(user_id: user.id, timestamp: Date())
let pulse = Pulse(login_event)
    .priority(.high)
    .tagged("auth", "security")
    .from(auth_service)
```

Each pulse contains:
- A unique identifier
- Creation timestamp
- Strongly-typed payload data
- System metadata

### Fluent Builder Pattern

Sable uses a fluent builder pattern for creating and modifying pulses, providing a natural language
interface that maintains immutability:

```swift
// Create an enhanced pulse with rich metadata
let enhanced_pulse = Pulse(login_event)
    .debug()                         // Mark for debugging
    .priority(.high)                 // Set processing priority
    .tagged("auth", "security")      // Add categorization tags
    .from(auth_service)              // Identify the source component

// Create a response that maintains the causal chain
let response_pulse = Pulse(AuthenticationCompleted(success: true))
    .echoes(enhanced_pulse)          // Establish causal relationship
```

### Message Tracing & Causality

Built-in support for tracing message flows and establishing causal relationships between messages:

```swift
// Original pulse with debug enabled
let original = Pulse(StartOperation(name: "sync"))
    .debug()                 // Enable debug tracing
    .from(sync_controller)   // Set source for context

// First handler creates a response in the chain
let second = Pulse.Respond(
    to: original,
    with: PrepareData(items: 42),
    from: data_service
)

// Second handler continues the chain
let third = Pulse.Respond(
    to: second,
    with: UploadStarted(batch_id: UUID()),
    from: network_service
)

// All pulses share the same trace ID but form a causal chain
// original.meta.trace == second.meta.trace == third.meta.trace
// third.meta.echoes?.id == second.id
// second.meta.echoes?.id == original.id
```

### Metadata & Context

Rich operational context that travels with messages, enabling:
- Operational tracing for debugging complex message flows
- Priority-based scheduling in async contexts
- Causal chain tracking to understand message relationships
- Filtering and routing based on tags

## Framework Structure

Sable is evolving to provide a cohesive, unified framework for reactive, event-driven systems:

### Current Status

- **Core Messaging Primitives**: The Pulse system (formerly SablePulse) is now fully integrated into the core Sable framework, providing the fundamental message types and metadata handling.

### Coming Soon

- **Transmission Primitives**: Building on the Pulse foundation, these components will enable sophisticated message routing, filtering, and processing across actor boundaries.

### Related Projects

- [**Obsidian**](https://github.com/beeauvin/Obsidian): Swift extensions and utilities that enhance the standard library with natural language alternatives (formerly SableFoundation)

## Getting Started

### Installation

Add Sable to your Swift package dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/beeauvin/Sable.git", from: "0.1.0")
]
```

### Basic Usage

Import Sable and start building:

```swift
import Sable  // Imports the core framework

// Define message types
struct UserLoggedIn: Pulsable {
    let user_id: UUID
    let timestamp: Date
}

struct AuthenticationCompleted: Pulsable {
    let success: Bool
    let user_id: UUID
}

// Create and customize a pulse
let login_pulse = Pulse(UserLoggedIn(user_id: user.id, timestamp: Date()))
    .priority(.high)
    .tagged("auth", "security")

// Create a response pulse
let auth_result = Pulse.Respond(
    to: login_pulse,
    with: AuthenticationCompleted(success: true, user_id: user.id)
)
```

## Integration Patterns

Sable provides the message primitives and reactive framework, but how you integrate them into your
application is entirely up to you:

### Event-Driven Architecture

Use Sable pulses as the foundation for event-driven systems:

```swift
// Create an event emitter for authentication events
let auth_emitter = PulseEmitter(source: auth_service)

// Emit events through the emitter
auth_emitter.emit(UserLoggedIn(user_id: user.id, timestamp: Date()))
    .priority(.high)
    .tagged("auth", "security")
```

### Actor-Based Systems

Sable is designed to work seamlessly with Swift's actor system:

```swift
actor AuthenticationService {
    let emitter: PulseEmitter
    
    init(emitter: PulseEmitter) {
        self.emitter = emitter
    }
    
    func authenticate(credentials: Credentials) async -> AuthResult {
        // Process authentication
        let result = // ... authentication logic
        
        // Emit a pulse with the result
        emitter.emit(AuthenticationCompleted(success: result.success, user_id: result.user_id))
            .priority(.high)
            .tagged("auth", "security")
            
        return result
    }
}
```

## License

🖤 Sable is available under the [Mozilla Public License 2.0](https://mozilla.org/MPL/2.0/).

A copy of the MPLv2 is included [license.md](/license.md) file for convenience.

## Contributing

While Sable is primarily developed for personal use, contributions are welcome. I do not have a
formal process for this in place at the moment but intend to adopt the
[Contributor Covenant](https://www.contributor-covenant.org) so those standards are the expectation.

The key consideration for contributions is alignment with Sable's core philosophy and design goals.
Technical improvements, documentation, and testing are all valuable areas for contribution.
See [contributing.md](/contributing.md) for more details.
