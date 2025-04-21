# 🖤 SablePulse

🖤 SablePulse provides type-safe message primitives for building event-based systems. As part of
the Sable framework, it prioritizes beautiful API design with natural language interfaces while
handling complex thread and memory safety internally.

## Overview

SablePulse offers immutable, strongly-typed message containers called "pulses" with rich metadata
that can be used as the foundation for implementing messaging systems in your applications. These
message primitives are designed to work with Swift's actor model and structured concurrency,
ensuring that message data is properly formed and thread-safe.

```swift
import SablePulse  // Use as a standalone module
```

## Core Features

- **Type-Safe Messaging Primitives**: Full generic type support without any type erasure
- **Actor-Ready Value Types**: Designed specifically for Swift's actor system
- **Natural Language API**: Expressive, readable method names that form cohesive sentences
- **Immutable Message Design**: All operations produce new message instances
- **Comprehensive Metadata**: Rich operational context that travels with messages
- **Tracing & Causality**: Built-in support for tracing message flows and causality chains
- **Memory Safety**: Designed with proper resource lifecycle management
- **Debugging Support**: Debug-specific features to enhance visibility during development

## Core Components

### Pulse

The `Pulse` struct is the central message primitive in SablePulse, encapsulating typed data
along with system metadata:

```swift
// Create a simple pulse with an event
let login_event = UserLoggedIn(user_id: user.id, timestamp: Date())
let pulse = Pulse(login_event)
```

Each pulse contains:
- A unique identifier
- Creation timestamp
- Strongly-typed payload data
- System metadata

### Pulsable

The `Pulsable` protocol defines requirements for types that can be used as pulse data:

```swift
public protocol Pulsable: Sendable, Equatable, Copyable, Codable, Hashable {}

// Example conformance
struct UserLoggedIn: Pulsable {
    let user_id: UUID
    let timestamp: Date
}

struct SettingsChanged: Pulsable {
    let settings: [String: Any]
    let changed_by: UUID
}
```

These requirements ensure pulse data can safely traverse actor boundaries, be cached, compared,
persisted, and used in collections.

### PulseMeta

The `PulseMeta` struct encapsulates system-level metadata about a pulse:

- Debug status for development and testing
- Tracing for message flow visualization
- Source tracking for message origin
- Echo tracking for causal relationships
- Priority for task scheduling
- Tags for filtering and categorization

## Fluent Builder Pattern

SablePulse uses a fluent builder pattern for creating and modifying pulses, providing a natural
language interface that maintains immutability:

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

Each method in the fluent chain returns a new pulse instance with the desired modifications,
preserving the original's identity information.

### Fluent Method Reference

SablePulse provides the following fluent builder methods for customizing pulses:

#### `debug(_ enabled: Bool = true)`
Marks a pulse for debug-specific handling such as additional logging, tracing, and visualization.
Particularly useful during development to track specific message flows.

#### `echoes<T: Pulsable>(_ pulse: Pulse<T>)`
Establishes a causal relationship with another pulse, maintaining both the trace ID and setting an
explicit reference to the original pulse. Use this when a pulse is emitted as a direct result of
processing another pulse.

#### `from(_ representable: any Representable)`
Sets the source component that generated this pulse, providing context for debugging and tracing
message flows. This identifies where in your system a particular message originated.

#### `priority(_ priority: TaskPriority)`
Sets the processing priority for this pulse, determining how urgently it should be handled. Works
directly with Swift's `TaskPriority` system for seamless integration with `async/await` code.

#### `tagged(_ tags: String..., reset: Bool = false)`
Adds string tags to the pulse for filtering, routing, and categorization. Tags provide a lightweight
extension mechanism without modifying the core structure. Set `reset` to `true` to replace existing
tags rather than adding to them.

#### `like<T: Pulsable>(_ pulse: Pulse<T>)`
Adopts all metadata from another pulse while preserving the current pulse's identity and data.
Useful for creating template pulses with consistent metadata that can be applied to different data
payloads.

## Responding to Pulses

SablePulse provides dedicated methods for creating response pulses that maintain causal chains:

```swift
// Create a response to a pulse
let response = Pulse.Respond(
    to: original_pulse,
    with: AuthCompleted(success: true),
    from: auth_service
)

// Equivalent to:
let response = Pulse(AuthCompleted(success: true))
    .echoes(original_pulse)
    .from(auth_service)
```

## Thread Safety

SablePulse is designed for use in actor-based, multi-threaded environments:

- All pulses are immutable value types
- All pulse data must conform to `Sendable`
- All operations create new instances rather than modifying existing ones
- No shared mutable state exists in the system

This design ensures that pulses can be safely passed between threads and actors without
synchronization concerns.

## Usage Patterns

SablePulse provides the message primitives, but how you integrate them into your application's
messaging infrastructure is entirely up to you. Any data that conforms to `Pulsable` can be
encapsulated in a pulse, allowing for a wide range of use cases:

### Basic Message Creation

```swift
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

### Tracing Message Flows

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

### Priority-Based Processing

```swift
// Critical system pulse
let critical_pulse = Pulse(SystemFailure(code: 500))
    .priority(.high)
    .tagged("critical", "alert")

// Background processing pulse
let background_pulse = Pulse(LogMetrics(count: 42))
    .priority(.low)
    .tagged("metrics", "background")

// Use pulse priority directly with Swift's task system
Task(priority: critical_pulse.priority) {
    // Handle critical pulse processing
}

Task(priority: background_pulse.priority) {
    // Handle background pulse processing
}
```

### Pulse Templates

```swift
// Create a template pulse with common metadata
let template = Pulse(Empty())
    .debug(is_debug_build)
    .priority(.medium)
    .tagged("module-x", "user-initiated")
    .from(current_module)

// Use the template for new pulses
let new_pulse = Pulse(UserAction(type: .tap))
    .like(template)  // Adopt all metadata from the template
```

## Integration

SablePulse provides the message primitives but doesn't implement the actual message transport or routing:

- Use SablePulse independently as a foundation for your own messaging infrastructure
- Build your own message dispatcher, subscription system, or event bus on top of these primitives
- Integrate with existing actor-based systems by using pulses as the message format
- Extend with custom pulse types specific to your application domain

While SablePulse is designed to work seamlessly with other Sable modules, it stands alone as a 
library of message primitives that can be used in any Swift application.
