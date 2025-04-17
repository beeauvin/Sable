// Copyright © 2025 Cassidy Spring. 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Testing

@testable import SableFoundation

@Suite("SableFoundation/Extensions/Optional: Transform")
struct OptionalTransformTests {
  
  // MARK: - Direct Transform Tests
  
  @Test("transform(_:) returns transformed value when non-nil")
  func transform_returns_transformed_value_when_non_nil() throws {
    // Given
    let optional: String? = "Hello"
    
    // When
    let result = optional.transform { string in
      string.count
    }
    
    // Then
    #expect(result == 5)
  }
  
  @Test("transform(_:) returns nil when original is nil")
  func transform_returns_nil_when_original_is_nil() throws {
    // Given
    let optional: String? = nil
    
    // When
    let result = optional.transform { string in
      string.count
    }
    
    // Then
    #expect(result == nil)
  }
  
  // MARK: - Optional Transform Tests
  
  @Test("transform(_:) with optional-returning closure returns transformed value when non-nil")
  func transform_optional_returns_transformed_value_when_non_nil() throws {
    // Given
    let optional: String? = "42"
    
    // When
    let result = optional.transform { string in
      Int(string)
    }
    
    // Then
    #expect(result == 42)
  }
  
  @Test("transform(_:) with optional-returning closure returns nil when original is nil")
  func transform_optional_returns_nil_when_original_is_nil() throws {
    // Given
    let optional: String? = nil
    
    // When
    let result = optional.transform { string in
      Int(string)
    }
    
    // Then
    #expect(result == nil)
  }
  
  @Test("transform(_:) with optional-returning closure returns nil when transformation fails")
  func transform_optional_returns_nil_when_transformation_fails() throws {
    // Given
    let optional: String? = "not a number"
    
    // When
    let result = optional.transform { string in
      Int(string)
    }
    
    // Then
    #expect(result == nil)
  }
  
  // MARK: - Method Overloading Tests
  
  @Test("transform correctly selects the appropriate overload based on closure return type")
  func transform_correctly_selects_appropriate_overload() throws {
    // Given
    let optional: String? = "42"
    
    // When - Direct transformation (should use map internally)
    let length = optional.transform { string in
      string.count
    }
    
    // When - Optional transformation (should use flatMap internally)
    let number = optional.transform { string in
      Int(string)
    }
    
    // Then
    #expect(length == 2)
    #expect(number == 42)
  }
  
  // MARK: - Chaining Tests
  
  @Test("transform can be chained with other optional methods")
  func transform_can_be_chained() throws {
    // Given
    let optional: String? = "42"
    
    // When - Chain transforms
    let result = optional
      .transform { string in Int(string) }
      .transform { number in number * 2 }
      .otherwise(0)
    
    // Then
    #expect(result == 84)
  }
  
  @Test("transform chains handle nil at any point in the chain")
  func transform_chains_handle_nil() throws {
    // Given
    let optional: String? = "not a number"
    
    // When - Chain transforms with a failing conversion
    let result = optional
      .transform { string in Int(string) } // This will be nil
      .transform { number in number * 2 }  // This won't be called
      .otherwise(0)
    
    // Then
    #expect(result == 0)
  }
  
  // MARK: - Async Transform Tests
  
  @Test("async transform(_:) returns transformed value when non-nil")
  func async_transform_returns_transformed_value_when_non_nil() async throws {
    // Given
    let optional: String? = "Hello"
    
    // When
    let result = await optional.transform { string async in
      return string.count
    }
    
    // Then
    #expect(result == 5)
  }
  
  @Test("async transform(_:) returns nil when original is nil")
  func async_transform_returns_nil_when_original_is_nil() async throws {
    // Given
    let optional: String? = nil
    
    // When
    let result = await optional.transform { string async in
      return string.count
    }
    
    // Then
    #expect(result == nil)
  }
  
  @Test("async transform(_:) with optional-returning closure returns transformed value when non-nil")
  func async_transform_optional_returns_transformed_value_when_non_nil() async throws {
    // Given
    let optional: String? = "42"
    
    // When
    let result = await optional.transform { string async in
      return Int(string)
    }
    
    // Then
    #expect(result == 42)
  }
  
  @Test("async transform(_:) with optional-returning closure returns nil when original is nil")
  func async_transform_optional_returns_nil_when_original_is_nil() async throws {
    // Given
    let optional: String? = nil
    
    // When
    let result = await optional.transform { string async in
      return Int(string)
    }
    
    // Then
    #expect(result == nil)
  }
  
  @Test("async transform(_:) with optional-returning closure returns nil when transformation fails")
  func async_transform_optional_returns_nil_when_transformation_fails() async throws {
    // Given
    let optional: String? = "not a number"
    
    // When
    let result = await optional.transform { string async in
      return Int(string)
    }
    
    // Then
    #expect(result == nil)
  }
  
  // MARK: - Actor Isolation Tests
  
  @Test("async transform works with actor isolation")
  func async_transform_works_with_actors() async throws {
    // Given
    actor TestActor {
      private var call_count = 0
      
      func compute_value(_ input: Int) -> Int {
        call_count += 1
        return input * 2
      }
      
      func get_call_count() -> Int {
        return call_count
      }
    }
    
    let actor = TestActor()
    
    // Test with non-nil optional
    let optional_with_value: Int? = 21
    let result_with_value = await optional_with_value.transform { number in
      await actor.compute_value(number)
    }
    
    // Test with nil optional
    let optional_nil: Int? = nil
    let result_nil = await optional_nil.transform { number in
      await actor.compute_value(number)
    }
    
    // Then
    #expect(result_with_value == 42)
    #expect(result_nil == nil)
    #expect(await actor.get_call_count() == 1, "Actor should be called only once (for non-nil case)")
  }
}
