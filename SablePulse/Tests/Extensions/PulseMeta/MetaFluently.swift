// Copyright © 2025 Cassidy Spring. 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Testing
import SableFoundation

@testable import SablePulse

@Suite("SablePulse/PulseMeta/Fluent")
struct PulseMetaFluentTests {
  
  // MARK: - Helpers
  
  struct TestRepresentable: Representable {
    let id = UUID()
    let name = "Test Source"
  }
  
  // MARK: - Static Fluently Method Tests
  
  @Test("Fluently preserves unmodified properties")
  func fluently_preserves_unmodified_properties() throws {
    // Given
    let original = PulseMeta()
    
    // When
    let updated = PulseMeta.Fluently(original, debug: true)
    
    // Then
    #expect(updated.trace == original.trace)
    #expect(updated.source == original.source)
    #expect(updated.echoes == original.echoes)
    #expect(updated.priority == original.priority)
    #expect(updated.tags == original.tags)
  }
  
  @Test("Fluently updates debug flag")
  func fluently_updates_debug_flag() throws {
    // Given
    let original = PulseMeta(debug: false)
    
    // When
    let updated = PulseMeta.Fluently(original, debug: true)
    
    // Then
    #expect(original.debug == false)
    #expect(updated.debug == true)
  }
  
  @Test("Fluently updates trace")
  func fluently_updates_trace() throws {
    // Given
    let original = PulseMeta()
    let new_trace = UUID()
    
    // When
    let updated = PulseMeta.Fluently(original, trace: new_trace)
    
    // Then
    #expect(updated.trace == new_trace)
  }
  
  @Test("Fluently updates source")
  func fluently_updates_source() throws {
    // Given
    let original = PulseMeta()
    let source = PulseSource.From(source: TestRepresentable())
    
    // When
    let updated = PulseMeta.Fluently(original, source: source)
    
    // Then
    #expect(updated.source?.id == source.id)
  }
  
  @Test("Fluently updates echoes")
  func fluently_updates_echoes() throws {
    // Given
    let original = PulseMeta()
    let echo = PulseSource.From(source: TestRepresentable())
    
    // When
    let updated = PulseMeta.Fluently(original, echoes: echo)
    
    // Then
    #expect(updated.echoes?.id == echo.id)
  }
  
  @Test("Fluently updates priority")
  func fluently_updates_priority() throws {
    // Given
    let original = PulseMeta(priority: .low)
    
    // When
    let updated = PulseMeta.Fluently(original, priority: .high)
    
    // Then
    #expect(updated.priority == TaskPriority.high.rawValue)
  }
  
  @Test("Fluently updates tags")
  func fluently_updates_tags() throws {
    // Given
    let original = PulseMeta()
    let new_tags: Set<String> = ["test", "fluent"]
    
    // When
    let updated = PulseMeta.Fluently(original, tags: new_tags)
    
    // Then
    #expect(updated.tags == new_tags)
  }
  
  @Test("Fluently handles empty tags")
  func fluently_handles_empty_tags() throws {
    // Given
    let original = PulseMeta(tags: ["original"])
    let empty_tags: Set<String> = []
    
    // When
    let updated = PulseMeta.Fluently(original, tags: empty_tags)
    
    // Then
    #expect(updated.tags.isEmpty)
  }
  
  // MARK: - Instance fluently Method Tests
  
  @Test("Instance fluently forwards to static Fluently")
  func instance_fluently_forwards_to_static_fluently() throws {
    // Given
    let original = PulseMeta()
    let debug = true
    
    // When - Both methods with same parameter
    let static_result = PulseMeta.Fluently(original, debug: debug)
    let instance_result = original.fluently(debug: debug)
    
    // Then
    #expect(static_result.debug == instance_result.debug)
  }
  
  @Test("Instance fluently enables method chaining")
  func instance_fluently_enables_method_chaining() throws {
    // Given
    let original = PulseMeta()
    
    // When - Chain multiple individual property updates
    let result = original
      .fluently(debug: true)
      .fluently(priority: .high)
    
    // Then
    #expect(result.debug == true)
    #expect(result.priority == TaskPriority.high.rawValue)
  }
  
  @Test("Instance fluently maintains immutability")
  func instance_fluently_maintains_immutability() throws {
    // Given
    let original = PulseMeta(debug: false, priority: .low)
    
    // When
    let _ = original.fluently(debug: true, priority: .high)
    
    // Then - Original should be unchanged
    #expect(original.debug == false)
    #expect(original.priority == TaskPriority.low.rawValue)
  }
  
  @Test("Instance fluently updates multiple properties in one call")
  func instance_fluently_updates_multiple_properties() throws {
    // Given
    let original = PulseMeta()
    let new_trace = UUID()
    
    // When
    let updated = original.fluently(
      debug: true,
      trace: new_trace,
      priority: .high
    )
    
    // Then
    #expect(updated.debug == true)
    #expect(updated.trace == new_trace)
    #expect(updated.priority == TaskPriority.high.rawValue)
  }
}
