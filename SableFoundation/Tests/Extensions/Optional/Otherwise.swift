// Copyright © 2025 Cassidy Spring. 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Testing

@testable import SableFoundation

@Suite("SableFoundation/Extensions/Optional: Otherwise")
struct OptionalOtherwiseTests {

  // MARK: - Otherwise Value Tests

  @Test("otherwise(_:) returns wrapped value when non-nil")
  func otherwise_returns_wrapped_value_when_non_nil() throws {
    // Given
    let optional: String? = "Value"

    // When
    let result = optional.otherwise("Default")

    // Then
    #expect(result == "Value")
  }

  @Test("otherwise(_:) returns default value when nil")
  func otherwise_returns_default_value_when_nil() throws {
    // Given
    let optional: String? = nil

    // When
    let result = optional.otherwise("Default")

    // Then
    #expect(result == "Default")
  }

  // MARK: - Otherwise Closure Tests

  @Test("otherwise(closure:) returns wrapped value when non-nil")
  func otherwise_closure_returns_wrapped_value_when_non_nil() throws {
    // Given
    let optional: Int? = 42
    var closure_called = false

    // When
    let result = optional.otherwise {
      closure_called = true
      return 0
    }

    // Then
    #expect(result == 42)
    #expect(!closure_called, "Closure should not be called when optional has a value")
  }

  @Test("otherwise(closure:) evaluates and returns closure result when nil")
  func otherwise_closure_evaluates_closure_when_nil() throws {
    // Given
    let optional: Int? = nil
    var closure_called = false

    // When
    let result = optional.otherwise {
      closure_called = true
      return 99
    }

    // Then
    #expect(result == 99)
    #expect(closure_called, "Closure should be called when optional is nil")
  }

  // MARK: - Async Otherwise Tests

  @Test("otherwise(async_closure:) returns wrapped value when non-nil")
  func otherwise_async_returns_wrapped_value_when_non_nil() async throws {
    // Given
    let optional: Double? = 3.14
    var closure_called = false

    func async_closure() async -> Double {
      closure_called = true
      return 0.0
    }

    // When
    let result = await optional.otherwise(async_closure)

    // Then
    #expect(result == 3.14)
    #expect(!closure_called, "Async closure should not be called when optional has a value")
  }

  @Test("otherwise(async_closure:) awaits and returns closure result when nil")
  func otherwise_async_evaluates_closure_when_nil() async throws {
    // Given
    let optional: Double? = nil
    var closure_called = false

    func async_closure() async -> Double {
      closure_called = true
      return 2.71
    }

    // When
    let result = await optional.otherwise(async_closure)

    // Then
    #expect(result == 2.71)
    #expect(closure_called, "Async closure should be called when optional is nil")
  }

  // MARK: - Actor Otherwise Tests
  /// This is a special case for validating cross thread boundary support.
  /// It should generally be a given but is included for extra validation.
  @Test("otherwise works with actor isolation")
  func otherwise_works_with_actors() async throws {
    // Given
    actor TestActor {
      private var call_count = 0

      func compute_value() -> String {
        call_count += 1
        return "Actor Value"
      }

      func get_call_count() -> Int {
        return call_count
      }
    }

    let actor = TestActor()

    // Test with non-nil optional
    let optional_with_value: String? = "Original Value"
    let result_with_value = await optional_with_value.otherwise {
      await actor.compute_value()
    }

    // Test with nil optional
    let optional_nil: String? = nil
    let result_nil = await optional_nil.otherwise {
      await actor.compute_value()
    }

    // Then
    #expect(result_with_value == "Original Value")
    #expect(result_nil == "Actor Value")
    #expect(await actor.get_call_count() == 1, "Actor should be called only once (for nil case)")
  }
}
