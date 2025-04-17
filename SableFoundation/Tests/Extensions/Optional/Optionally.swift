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
    var closure_called = false
    
    // When
    let result = optional.optionally {
      closure_called = true
      return 99
    }
    
    // Then
    #expect(result == 42)
    #expect(!closure_called, "Closure should not be called when optional has a value")
  }
  
  @Test("optionally(closure:) evaluates and returns closure result when nil")
  func optionally_closure_evaluates_closure_when_nil() throws {
    // Given
    let optional: Int? = nil
    var closure_called = false
    
    // When
    let result = optional.optionally {
      closure_called = true
      return 99
    }
    
    // Then
    #expect(result == 99)
    #expect(closure_called, "Closure should be called when optional is nil")
  }
  
  @Test("optionally(closure:) returns nil when closure returns nil")
  func optionally_closure_returns_nil_when_closure_returns_nil() throws {
    // Given
    let optional: Int? = nil
    var closure_called = false
    
    // When
    let result = optional.optionally {
      closure_called = true
      return nil
    }
    
    // Then
    #expect(result == nil)
    #expect(closure_called, "Closure should be called when optional is nil")
  }
  
  @Test("optionally(closure:) chains with otherwise for guaranteed values")
  func optionally_closure_chains_with_otherwise_for_guaranteed_values() throws {
    // Given
    let optional: Int? = nil
    let default_value = 42
    
    // When
    let result = optional.optionally {
      return nil
    }.otherwise(default_value)
    
    // Then
    #expect(result == default_value)
  }
  
  // MARK: - Async Optionally Tests
  
  @Test("optionally(async_closure:) returns wrapped value when non-nil")
  func optionally_async_returns_wrapped_value_when_non_nil() async throws {
    // Given
    let optional: Double? = 3.14
    var closure_called = false
    
    func async_closure() async -> Double? {
      closure_called = true
      return 2.71
    }
    
    // When
    let result = await optional.optionally(async_closure)
    
    // Then
    #expect(result == 3.14)
    #expect(!closure_called, "Async closure should not be called when optional has a value")
  }
  
  @Test("optionally(async_closure:) awaits and returns closure result when nil")
  func optionally_async_evaluates_closure_when_nil() async throws {
    // Given
    let optional: Double? = nil
    var closure_called = false
    
    func async_closure() async -> Double? {
      closure_called = true
      return 2.71
    }
    
    // When
    let result = await optional.optionally(async_closure)
    
    // Then
    #expect(result == 2.71)
    #expect(closure_called, "Async closure should be called when optional is nil")
  }
  
  @Test("optionally(async_closure:) returns nil when closure returns nil")
  func optionally_async_returns_nil_when_closure_returns_nil() async throws {
    // Given
    let optional: Double? = nil
    var closure_called = false
    
    func async_closure() async -> Double? {
      closure_called = true
      return nil
    }
    
    // When
    let result = await optional.optionally(async_closure)
    
    // Then
    #expect(result == nil)
    #expect(closure_called, "Async closure should be called when optional is nil")
  }
  
  @Test("optionally(async_closure:) chains with otherwise for guaranteed values")
  func optionally_async_chains_with_otherwise_for_guaranteed_values() async throws {
    // Given
    let optional: Double? = nil
    let default_value = 3.14
    var closure_called = false
    
    func async_closure() async -> Double? {
      closure_called = true
      return nil
    }
    
    // When
    let result = await optional.optionally(async_closure).otherwise(default_value)
    
    // Then
    #expect(result == default_value)
    #expect(closure_called, "Async closure should be called when optional is nil")
  }
  
  // MARK: - Actor Otherwise Tests
  /// This is a special case for validating cross thread boundary support.
  /// It should generally be a given but is included for extra validation.
  @Test("optionally works with actor isolation")
  func optionally_works_with_actors() async throws {
    // Given
    actor TestActor {
      private var call_count = 0
      
      func compute_optional_value() -> String? {
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
    let result_with_value = await optional_with_value.optionally {
      await actor.compute_optional_value()
    }
    
    // Test with nil optional
    let optional_nil: String? = nil
    let result_nil = await optional_nil.optionally {
      await actor.compute_optional_value()
    }
    
    // Then
    #expect(result_with_value == "Original Value")
    #expect(result_nil == "Actor Value")
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
    var closure_called = false
    
    // When
    let result = first.optionally(second).optionally {
      closure_called = true
      return "From Closure"
    }.otherwise(default_value)
    
    // Then
    #expect(result == "From Closure")
    #expect(closure_called, "Closure should be called in the chain")
  }
  
  @Test("async and sync optionally can be chained with otherwise")
  func async_and_sync_optionally_can_be_chained_with_otherwise() async throws {
    // Given
    let first: String? = nil
    let default_value = "Default"
    var closure_called = false
    
    func async_compute() async -> String? {
      closure_called = true
      return "Async Value"
    }
    
    // When
    let result = await first.optionally(async_compute).otherwise(default_value)
    
    // Then
    #expect(result == "Async Value")
    #expect(closure_called, "Async closure should be called in the chain")
  }
}
