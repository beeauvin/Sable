# 🖤 SableFoundation

**DEPRECATED - USE [Obsidian](https://github.com/beeauvin/Obsidian) INSTEAD**

🖤 SableFoundation is a drop-in replacement for Swift's Foundation library,
providing elegant natural language extensions and utilities that enhance the
standard Swift types.

## Overview

SableFoundation serves as a core component of the Sable framework, extending
Swift's built-in types with expressive, readable APIs that prioritize developer
experience. Since SableFoundation re-exports Foundation
(`@_exported import Foundation`), you only need to import SableFoundation in
your files:

```swift
import SableFoundation  // No need to also import Foundation
```

## Features

### Optional Extensions

SableFoundation provides a suite of natural language extensions for Swift's Optional type that make
working with optionals more expressive and readable.

#### `otherwise` - A natural language alternative to nil-coalescing (`??`)

```swift
// Instead of:
let display_name = username ?? "Guest"

// Use:
let display_name = username.otherwise("Guest")
```

Three variants are available:

```swift
// With a direct default value
let result = optional_value.otherwise(defaultValue)

// With a closure for lazy evaluation
let result = optional_value.otherwise {
    perform_expensive_computation()
}

// With an async closure (fully supports actors)
let result = await optional_value.otherwise {
    await perform_async_operation()
}
```

#### `transform` - A natural language alternative to map/flatMap

```swift
// Instead of:
let name_length = username.map { $0.count }

// Use:
let name_length = username.transform { name in
    name.count
}

// For transformations that might return nil (flatMap):
let number = numeric_string.transform { string in
    Int(string)  // Returns Int? (might be nil if string isn't numeric)
}

// With async support:
let user_profile = await user_id.transform { id in
    await user_service.fetch_profile(for: id)
}
```

#### `when` - Conditional execution based on optional presence

```swift
// Execute code when optional contains a value:
let greeting = user.when(something: { person in
    "Hello, \(person.name)!"
})

// Execute code when optional is nil:
user.when(nothing: {
    analytics.log_anonymous_visit()
})

// Handle both cases with a single method:
let greeting = user.when(
    something: { person in
        "Hello, \(person.name)!"
    },
    nothing: {
        "Hello, Guest!"
    }
)

// With async support:
let profile_data = await user.when(
    something: { person in
        await profile_service.fetch_profile(for: person.id)
    },
    nothing: {
        await profile_service.fetch_default_profile()
    }
)
```

#### `optionally` - Chaining multiple optionals

```swift
// Instead of:
let result = primary_value ?? backup_value ?? "Default"

// Use:
let result = primary_value.optionally(backup_value).otherwise("Default")

// With lazy evaluation:
let result = cached_result.optionally {
    compute_expensive_fallback()  // Returns another optional
}.otherwise("Default")

// With async support:
let value = await local_value.optionally {
    await remote_service.fetch_optional_value()
}.otherwise("Default")
```

### Protocols

SableFoundation includes several protocols that provide consistent interfaces across types:

#### `Uniquable` - Unique identification with UUID

```swift
struct User: Uniquable {
    let id = UUID()
    let name: String
}
```

The `Uniquable` protocol extends `Identifiable` to specifically use `UUID` as the identifier type,
ensuring standardized unique identification across your application.

#### `Namable` - Consistent naming convention

```swift
struct Product: Namable {
    // Uses default implementation: returns "Product"
}

struct CustomProduct: Namable {
    let name: String  // Custom implementation: returns this value

    init(name: String) {
        self.name = name
    }
}
```

The `Namable` protocol provides a consistent way to access a human-readable name for types. It
includes a default implementation that returns the type name as a string.

#### `Describable` - Textual descriptions

```swift
struct Message: Describable {
    let sender: String
    let content: String

    var description: String {
        return "\(sender): \(content)"
    }
}
```

The `Describable` protocol offers a consistent way to get a human-readable description of types for
logging, debugging, or displaying information to users.

#### `Representable` - Combined representation

```swift
struct User: Representable {
    let id = UUID()
    // Uses default implementations for name and description
}
```

The `Representable` protocol combines `Uniquable`, `Namable`, and `Describable` to provide a
complete representation for an object. By default, a `Representable` object's description will be
its name followed by its UUID.

## Examples

### Combining Optional Extensions

```swift
// Using transform, optionally, and otherwise together
let user_id: UUID? = get_current_user_id()
let profile = await user_id
    .transform { id in await user_service.fetch_profile(for: id) }
    .optionally { await user_service.fetch_cached_profile() }
    .otherwise { DefaultProfile() }

// Using when for conditional logic with async code
let cached_data: Data? = cache.retrieve(key)
await cached_data.when(
    something: { data in
        await process_and_update(data)
    },
    nothing: {
        await fetch_and_cache(key)
    }
)
```

### Using Protocols Together

```swift
// A type that provides identity, name, and description
struct Product: Representable {
    let id = UUID()
    let name: String
    let price: Decimal
    
    init(name: String, price: Decimal) {
        self.name = name
        self.price = price
    }
    
    // Override the default description
    var description: String {
        return "\(name) ($\(price))"
    }
}

let product = Product(name: "Deluxe Widget", price: 29.99)
print(product.id)          // UUID
print(product.name)        // "Deluxe Widget"
print(product.description) // "Deluxe Widget ($29.99)"
```
