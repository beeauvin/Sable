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
    var tracker = ClosureTracker()
    
    // When
    let result = optional.otherwise {
      tracker.track()
      return 0
    }
    
    // Then
    #expect(result == 42)
    tracker.verify(called: false, message: "Closure should not be called when optional has a value")
  }
  
  @Test("otherwise(closure:) evaluates and returns closure result when nil")
  func otherwise_closure_evaluates_closure_when_nil() throws {
    // Given
    let optional: Int? = nil
    var tracker = ClosureTracker()
    
    // When
    let result = optional.otherwise {
      tracker.track()
      return 99
    }
    
    // Then
    #expect(result == 99)
    tracker.verify(called: true, message: "Closure should be called when optional is nil")
  }
  
  // MARK: - Async Otherwise Tests
  
  @Test("otherwise(async_closure:) returns wrapped value when non-nil")
  func otherwise_async_returns_wrapped_value_when_non_nil() async throws {
    // Given
    let optional: Double? = 3.14
    var tracker = ClosureTracker()
    
    func async_closure() async -> Double {
      tracker.track()
      return 0.0
    }
    
    // When
    let result = await optional.otherwise(async_closure)
    
    // Then
    #expect(result == 3.14)
    tracker.verify(called: false, message: "Async closure should not be called when optional has a value")
  }
  
  @Test("otherwise(async_closure:) awaits and returns closure result when nil")
  func otherwise_async_evaluates_closure_when_nil() async throws {
    // Given
    let optional: Double? = nil
    var tracker = ClosureTracker()
    
    func async_closure() async -> Double {
      tracker.track()
      return 2.71
    }
    
    // When
    let result = await optional.otherwise(async_closure)
    
    // Then
    #expect(result == 2.71)
    tracker.verify(called: true, message: "Async closure should be called when optional is nil")
  }
  
  // MARK: - Actor Otherwise Tests
  
  @Test("otherwise works with actor isolation")
  func otherwise_works_with_actors() async throws {
    // Given
    let actor = TestActor()
    
    // Test with non-nil optional
    let optional_with_value: String? = "Original Value"
    let result_with_value = await optional_with_value.otherwise {
      await actor.compute_default_string()
    }
    
    // Test with nil optional
    let optional_nil: String? = nil
    let result_nil = await optional_nil.otherwise {
      await actor.compute_default_string()
    }
    
    // Then
    #expect(result_with_value == "Original Value")
    #expect(result_nil == "DEFAULT")
    #expect(await actor.get_call_count() == 1, "Actor should be called only once (for nil case)")
  }
}
