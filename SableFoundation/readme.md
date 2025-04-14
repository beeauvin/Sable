# 🖤 SableFoundation

🖤 SableFoundation is a drop-in replacement for Swift's Foundation library, providing elegant natural language extensions and utilities that enhance the standard Swift types.

## Overview

🖤 SableFoundation serves as a core component of the Sable framework, extending Swift's built-in types with expressive, readable APIs that prioritize developer experience. Since 🖤 SableFoundation re-exports Foundation (`@_exported import Foundation`), you only need to import 🖤 SableFoundation in your files:

```swift
import SableFoundation  // No need to also import Foundation
```

## Current Features

### Optional Extensions

#### `otherwise` - A natural language alternative to nil-coalescing (`??`)

```swift
// Instead of:
let displayName = username ?? "Guest"

// Use:
let displayName = username.otherwise("Guest")
```

Three variants are available:

```swift
// With a direct default value
let result = optionalValue.otherwise(defaultValue)

// With a closure for lazy evaluation
let result = optionalValue.otherwise {
    perform_expensive_computation()
}

// With an async closure (fully supports actors)
let result = await optionalValue.otherwise {
    await perform_async_operation()
}
```

#### Benefits of `otherwise`

- Reads more naturally in code
- Provides clear intent compared to the symbolic operator
- Offers ergonomic async support
- Complements Swift 6's improved optional handling

## Examples

### Basic Usage

```swift
let cached_result: ExpensiveComputationResult? = cache.retrieve(key)
let result = cached_result.otherwise {
    let computed = perform_expensive_computation()
    cache.store(computed, for: key)
    return computed
}
```

### With Async Code

```swift
// With actor-isolated code
let cached_value = await cache.retrieve_value(for: key)
let value = await cached_value.otherwise {
    // Swift will enforce @Sendable requirement at the actor boundary
    await some_actor.compute_something()
}
```
