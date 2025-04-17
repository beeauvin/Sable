// Copyright © 2025 Cassidy Spring. 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Testing

@testable import SableFoundation

@Suite("SableFoundation/Extensions/Optional: Optionally")
struct OptionalOptionallyTests {
  
  // MARK: - Optionally Value Tests
  
  @Test("optionally(_:) returns wrapped value when non-nil")
  func optionally_returns_wrapped_value_when_non_nil() throws {
    // Given
    let optional: String? = "Value"
    let fallback: String? = "Fallback"
    
    // When
    let result = optional.optionally(fallback)
    
    // Then
    #expect(result == "Value")
  }
  
  @Test("optionally(_:) returns fallback optional when nil")
  func optionally_returns_fallback_optional_when_nil() throws {
    // Given
    let optional: String? = nil
    let fallback: String? = "Fallback"
    
    // When
    let result = optional.optionally(fallback)
    
    // Then
    #expect(result == "Fallback")
  }
  
  @Test("optionally(_:) returns nil when both optionals are nil")
  func optionally_returns_nil_when_both_optionals_are_nil() throws {
    // Given
    let optional: String? = nil
    let fallback: String? = nil
    
    // When
    let result = optional.optionally(fallback)
    
    // Then
    #expect(result == nil)
  }
  
  @Test("optionally(_:) chains with otherwise for guaranteed values")
  func optionally_chains_with_otherwise_for_guaranteed_values() throws {
    // Given
    let first: String? = nil
    let second: String? = nil
    let default_value = "Default"
    
    // When
    let result = first.optionally(second).otherwise(default_value)
    
    // Then
    #expect(result == default_value)
  }
  
  // MARK: - Optionally Closure Tests
  
  @Test("optionally(closure:) returns wrapped value when non-nil")
  func optionally_closure_returns_wrapped_value_when_non_nil() throws {
    // Given
    let optional: Int? = 42
    var tracker = ClosureTracker()
    
    // When
    let result = optional.optionally {
      tracker.track()
      return 99
    }
    
    // Then
    tracker.verify(called: false, message: "Closure should not be called when optional has a value")
    #expect(result == 42)
  }
  
  @Test("optionally(closure:) evaluates and returns closure result when nil")
  func optionally_closure_evaluates_closure_when_nil() throws {
    // Given
    let optional: Int? = nil
    var tracker = ClosureTracker()
    
    // When
    let result = optional.optionally {
      tracker.track()
      return 99
    }
    
    // Then
    tracker.verify(called: true, message: "Closure should be called when optional is nil")
    #expect(result == 99)
  }
  
  @Test("optionally(closure:) returns nil when closure returns nil")
  func optionally_closure_returns_nil_when_closure_returns_nil() throws {
    // Given
    let optional: Int? = nil
    var tracker = ClosureTracker()
    
    // When
    let result = optional.optionally {
      tracker.track()
      return nil
    }
    
    // Then
    tracker.verify(called: true, message: "Closure should be called when optional is nil")
    #expect(result == nil)
  }
  
  // MARK: - Async Optionally Tests
  
  @Test("optionally(async_closure:) returns wrapped value when non-nil")
  func optionally_async_returns_wrapped_value_when_non_nil() async throws {
    // Given
    let optional: Double? = 3.14
    var tracker = ClosureTracker()
    
    func async_provider() async -> Double? {
      tracker.track()
      return 2.71
    }
    
    // When
    let result = await optional.optionally(async_provider)
    
    // Then
    tracker.verify(called: false, message: "Async closure should not be called when optional has a value")
    #expect(result == 3.14)
  }
  
  @Test("optionally(async_closure:) awaits and returns closure result when nil")
  func optionally_async_evaluates_closure_when_nil() async throws {
    // Given
    let optional: Double? = nil
    var tracker = ClosureTracker()
    
    func async_provider() async -> Double? {
      tracker.track()
      return 2.71
    }
    
    // When
    let result = await optional.optionally(async_provider)
    
    // Then
    tracker.verify(called: true, message: "Async closure should be called when optional is nil")
    #expect(result == 2.71)
  }
  
  @Test("optionally(async_closure:) returns nil when closure returns nil")
  func optionally_async_returns_nil_when_closure_returns_nil() async throws {
    // Given
    let optional: Double? = nil
    var tracker = ClosureTracker()
    
    func async_provider() async -> Double? {
      tracker.track()
      return nil
    }
    
    // When
    let result = await optional.optionally(async_provider)
    
    // Then
    tracker.verify(called: true, message: "Async closure should be called when optional is nil")
    #expect(result == nil)
  }
  
  // MARK: - Actor Isolation Tests
  
  @Test("optionally works with actor isolation")
  func optionally_works_with_actors() async throws {
    // Given
    let actor = TestActor()
    
    // Test with non-nil optional
    let optional_with_value: String? = "Original Value"
    let result_with_value = await optional_with_value.optionally {
      await actor.compute_default_string()
    }
    
    // Test with nil optional
    let optional_nil: String? = nil
    let result_nil = await optional_nil.optionally {
      await actor.compute_default_string()
    }
    
    // Then
    #expect(result_with_value == "Original Value")
    #expect(result_nil == "DEFAULT")
    #expect(await actor.get_call_count() == 1, "Actor should be called only once (for nil case)")
  }
  
  // MARK: - Multiple Chain Tests
  
  @Test("multiple optionally calls can be chained")
  func multiple_optionally_calls_can_be_chained() throws {
    // Given
    let first: String? = nil
    let second: String? = nil
    let third: String? = "Third"
    let default_value = "Default"
    
    // When
    let result = first.optionally(second).optionally(third).otherwise(default_value)
    
    // Then
    #expect(result == "Third")
  }
  
  @Test("mix of optionally with closures and values can be chained")
  func mix_of_optionally_with_closures_and_values_can_be_chained() throws {
    // Given
    let first: String? = nil
    let second: String? = nil
    let default_value = "Default"
    var tracker = ClosureTracker()
    
    // When
    let result = first.optionally(second).optionally {
      tracker.track()
      return "From Closure"
    }.otherwise(default_value)
    
    // Then
    #expect(result == "From Closure")
    tracker.verify(called: true, message: "Closure should be called in the chain")
  }
  
  @Test("async and sync optionally can be chained with otherwise")
  func async_and_sync_optionally_can_be_chained_with_otherwise() async throws {
    // Given
    let first: String? = nil
    let default_value = "Default"
    var tracker = ClosureTracker()
    
    func async_compute() async -> String? {
      tracker.track()
      return "Async Value"
    }
    
    // When
    let result = await first.optionally(async_compute).otherwise(default_value)
    
    // Then
    tracker.verify(called: true, message: "Async closure should be called in the chain")
    #expect(result == "Async Value")
  }
}
