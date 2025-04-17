// Copyright © 2025 Cassidy Spring. 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Testing

@testable import SableFoundation

@Suite("SableFoundation/Extensions/Optional: When")
struct OptionalWhenTests {
  
  // MARK: - When Something Tests
  
  @Test("when(something:) executes closure with wrapped value when non-nil")
  func when_something_executes_with_wrapped_value_when_non_nil() throws {
    // Given
    let optional: String? = "Value"
    var closure_called = false
    var passed_value = ""
    
    // When
    let result = optional.when(something: { value in
      closure_called = true
      passed_value = value
      return value.uppercased()
    })
    
    // Then
    #expect(closure_called, "Closure should be called when optional has a value")
    #expect(passed_value == "Value", "Wrapped value should be passed to closure")
    #expect(result == "VALUE", "Result should be the closure's return value")
  }
  
  @Test("when(something:) returns nil when optional is nil")
  func when_something_returns_nil_when_optional_is_nil() throws {
    // Given
    let optional: String? = nil
    var closure_called = false
    
    // When
    let result = optional.when(something: { value in
      closure_called = true
      return value.uppercased()
    })
    
    // Then
    #expect(!closure_called, "Closure should not be called when optional is nil")
    #expect(result == nil, "Result should be nil when optional is nil")
  }
  
  // MARK: - When Nothing Tests
  
  @Test("when(nothing:) executes closure when optional is nil")
  func when_nothing_executes_closure_when_optional_is_nil() throws {
    // Given
    let optional: String? = nil
    var closure_called = false
    
    // When
    optional.when(nothing: {
      closure_called = true
    })
    
    // Then
    #expect(closure_called, "Closure should be called when optional is nil")
  }
  
  @Test("when(nothing:) does not execute closure when optional is non-nil")
  func when_nothing_does_not_execute_closure_when_optional_is_non_nil() throws {
    // Given
    let optional: String? = "Value"
    var closure_called = false
    
    // When
    optional.when(nothing: {
      closure_called = true
    })
    
    // Then
    #expect(!closure_called, "Closure should not be called when optional has a value")
  }
  
  // MARK: - When Something or Nothing Tests
  
  @Test("when(something:nothing:) executes something closure when non-nil")
  func when_something_nothing_executes_something_when_non_nil() throws {
    // Given
    let optional: String? = "Value"
    var something_called = false
    var nothing_called = false
    
    // When
    let result = optional.when(
      something: { value in
        something_called = true
        return value.uppercased()
      },
      nothing: {
        nothing_called = true
        return "DEFAULT"
      }
    )
    
    // Then
    #expect(something_called, "Something closure should be called when optional has a value")
    #expect(!nothing_called, "Nothing closure should not be called when optional has a value")
    #expect(result == "VALUE", "Result should be from the something closure")
  }
  
  @Test("when(something:nothing:) executes nothing closure when nil")
  func when_something_nothing_executes_nothing_when_nil() throws {
    // Given
    let optional: String? = nil
    var something_called = false
    var nothing_called = false
    
    // When
    let result = optional.when(
      something: { value in
        something_called = true
        return value.uppercased()
      },
      nothing: {
        nothing_called = true
        return "DEFAULT"
      }
    )
    
    // Then
    #expect(!something_called, "Something closure should not be called when optional is nil")
    #expect(nothing_called, "Nothing closure should be called when optional is nil")
    #expect(result == "DEFAULT", "Result should be from the nothing closure")
  }
  
  // MARK: - Async When Something Tests
  
  @Test("async when(something:) executes closure with wrapped value when non-nil")
  func async_when_something_executes_with_wrapped_value_when_non_nil() async throws {
    // Given
    let optional: String? = "Value"
    var closure_called = false
    var passed_value = ""
    
    // When
    let result = await optional.when(something: { value async in
      closure_called = true
      passed_value = value
      return value.uppercased()
    })
    
    // Then
    #expect(closure_called, "Async closure should be called when optional has a value")
    #expect(passed_value == "Value", "Wrapped value should be passed to async closure")
    #expect(result == "VALUE", "Result should be the async closure's return value")
  }
  
  @Test("async when(something:) returns nil when optional is nil")
  func async_when_something_returns_nil_when_optional_is_nil() async throws {
    // Given
    let optional: String? = nil
    var closure_called = false
    
    // When
    let result = await optional.when(something: { value async in
      closure_called = true
      return value.uppercased()
    })
    
    // Then
    #expect(!closure_called, "Async closure should not be called when optional is nil")
    #expect(result == nil, "Result should be nil when optional is nil")
  }
  
  // MARK: - Async When Nothing Tests
  
  @Test("async when(nothing:) executes closure when optional is nil")
  func async_when_nothing_executes_closure_when_optional_is_nil() async throws {
    // Given
    let optional: String? = nil
    var closure_called = false
    
    func async_closure() async {
      closure_called = true
    }
    
    // When
    await optional.when(nothing: async_closure)
    
    // Then
    #expect(closure_called, "Async closure should be called when optional is nil")
  }
  
  @Test("async when(nothing:) does not execute closure when optional is non-nil")
  func async_when_nothing_does_not_execute_closure_when_optional_is_non_nil() async throws {
    // Given
    let optional: String? = "Value"
    var closure_called = false
    
    func async_closure() async {
      closure_called = true
    }
    
    // When
    await optional.when(nothing: async_closure)
    
    // Then
    #expect(!closure_called, "Async closure should not be called when optional has a value")
  }
  
  // MARK: - Async When Something or Nothing Tests
  
  @Test("async when(something:nothing:) executes something closure when non-nil")
  func async_when_something_nothing_executes_something_when_non_nil() async throws {
    // Given
    let optional: String? = "Value"
    var something_called = false
    var nothing_called = false
    
    // When
    let result = await optional.when(
      something: { value async in
        something_called = true
        return value.uppercased()
      },
      nothing: {
        nothing_called = true
        return "DEFAULT"
      }
    )
    
    // Then
    #expect(something_called, "Something async closure should be called when optional has a value")
    #expect(!nothing_called, "Nothing async closure should not be called when optional has a value")
    #expect(result == "VALUE", "Result should be from the something async closure")
  }
  
  @Test("async when(something:nothing:) executes nothing closure when nil")
  func async_when_something_nothing_executes_nothing_when_nil() async throws {
    // Given
    let optional: String? = nil
    var something_called = false
    var nothing_called = false
    
    // When
    let result = await optional.when(
      something: { value async in
        something_called = true
        return value.uppercased()
      },
      nothing: {
        nothing_called = true
        return "DEFAULT"
      }
    )
    
    // Then
    #expect(!something_called, "Something async closure should not be called when optional is nil")
    #expect(nothing_called, "Nothing async closure should be called when optional is nil")
    #expect(result == "DEFAULT", "Result should be from the nothing async closure")
  }
  
  // MARK: - Actor Isolation Tests
  
  @Test("async when works with actor isolation")
  func async_when_works_with_actors() async throws {
    // Given
    actor TestActor {
      private var call_count = 0
      
      func compute_value(_ input: String) -> String {
        call_count += 1
        return input.uppercased()
      }
      
      func compute_default() -> String {
        call_count += 1
        return "DEFAULT"
      }
      
      func get_call_count() -> Int {
        return call_count
      }
    }
    
    let actor = TestActor()
    
    // Test with non-nil optional
    let optional_with_value: String? = "value"
    let result_with_value = await optional_with_value.when(
      something: { value in
        await actor.compute_value(value)
      },
      nothing: {
        await actor.compute_default()
      }
    )
    
    // Test with nil optional
    let optional_nil: String? = nil
    let result_nil = await optional_nil.when(
      something: { value in
        await actor.compute_value(value)
      },
      nothing: {
        await actor.compute_default()
      }
    )
    
    // Then
    #expect(result_with_value == "VALUE")
    #expect(result_nil == "DEFAULT")
    #expect(await actor.get_call_count() == 2, "Actor should be called once for each test")
  }
}
