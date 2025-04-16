// Copyright © 2025 Cassidy Spring. 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Testing
import SableFoundation

@testable import SablePulse

@Suite("SablePulse/PulseMeta")
struct PulseMetaTests {
  
  // MARK: - Protocol Conformance Tests
  
  @Test("PulseMeta conforms to Pulsable")
  func pulse_meta_conforms_to_pulsable() throws {
    // Given
    let is_pulsable = (PulseMeta.self as Any) is any Pulsable.Type
    
    // Then
    #expect(is_pulsable)
  }
  
  // MARK: - Default Values Tests
  
  @Test("PulseMeta initializes with correct default values")
  func pulse_meta_initializes_with_default_values() throws {
    // When
    let meta = PulseMeta()
    
    // Then
    #expect(!meta.debug, "Debug should default to false")
    #expect(meta.source == nil, "Source should default to nil")
    #expect(meta.echoes == nil, "Echoes should default to nil")
    #expect(meta.priority == TaskPriority.medium.rawValue, "Priority should default to medium")
    #expect(meta.tags.isEmpty, "Tags should default to empty set")
  }
  
  // MARK: - Custom Values Tests
  
  @Test("PulseMeta initializes with custom debug value")
  func pulse_meta_initializes_with_custom_debug_value() throws {
    // When
    let meta = PulseMeta(debug: true)
    
    // Then
    #expect(meta.debug, "Debug should be set to true")
  }
  
  @Test("PulseMeta initializes with custom trace value")
  func pulse_meta_initializes_with_custom_trace_value() throws {
    // Given
    let custom_trace = UUID()
    
    // When
    let meta = PulseMeta(trace: custom_trace)
    
    // Then
    #expect(meta.trace == custom_trace, "Trace should match provided UUID")
  }
  
  @Test("PulseMeta initializes with custom source value")
  func pulse_meta_initializes_with_custom_source_value() throws {
    // Given
    struct TestRepresentable: Representable {
      let id = UUID()
      let name = "Test Source"
    }
    let source_representable = TestRepresentable()
    let source = PulseSource.From(source: source_representable)
    
    // When
    let meta = PulseMeta(source: source)
    
    // Then
    #expect(meta.source != nil, "Source should not be nil")
    #expect(meta.source?.id == source.id, "Source id should match provided source")
    #expect(meta.source?.name == source.name, "Source name should match provided source")
  }
  
  @Test("PulseMeta initializes with custom echoes value")
  func pulse_meta_initializes_with_custom_echoes_value() throws {
    // Given
    struct TestRepresentable: Representable {
      let id = UUID()
      let name = "Test Echo"
    }
    let echo_representable = TestRepresentable()
    let echo = PulseSource.From(source: echo_representable)
    
    // When
    let meta = PulseMeta(echoes: echo)
    
    // Then
    #expect(meta.echoes != nil, "Echoes should not be nil")
    #expect(meta.echoes?.id == echo.id, "Echoes id should match provided echo source")
    #expect(meta.echoes?.name == echo.name, "Echoes name should match provided echo source")
  }
  
  @Test("PulseMeta initializes with custom priority value")
  func pulse_meta_initializes_with_custom_priority_value() throws {
    // When
    let meta = PulseMeta(priority: .high)
    
    // Then
    #expect(meta.priority == TaskPriority.high.rawValue, "Priority should be set to high")
  }
  
  @Test("PulseMeta initializes with custom tags value")
  func pulse_meta_initializes_with_custom_tags_value() throws {
    // Given
    let custom_tags: Set<String> = ["feature_flag", "beta", "testing"]
    
    // When
    let meta = PulseMeta(tags: custom_tags)
    
    // Then
    #expect(meta.tags == custom_tags, "Tags should match provided set")
    #expect(meta.tags.count == 3, "Tags should contain exactly 3 items")
  }
  
  // MARK: - Serialization Tests
  
  @Test("PulseMeta can be encoded and decoded")
  func pulse_meta_can_be_encoded_and_decoded() throws {
    // Given
    struct TestRepresentable: Representable {
      let id = UUID()
      let name = "Test Source"
    }
    let source = PulseSource.From(source: TestRepresentable())
    let original = PulseMeta(
      debug: true,
      trace: UUID(),
      source: source,
      priority: .high,
      tags: ["test", "serialization"]
    )
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    // When
    let data = try encoder.encode(original)
    let decoded = try decoder.decode(PulseMeta.self, from: data)
    
    // Then
    #expect(decoded.debug == original.debug)
    #expect(decoded.trace == original.trace)
    #expect(decoded.source?.id == original.source?.id)
    #expect(decoded.source?.name == original.source?.name)
    #expect(decoded.echoes == original.echoes)
    #expect(decoded.priority == original.priority)
    #expect(decoded.tags == original.tags)
  }
  
  // MARK: - Equality Tests
  
  @Test("Equal PulseMeta instances compare as equal")
  func equal_pulse_meta_instances_compare_as_equal() throws {
    // Given
    let trace_id = UUID()
    let tags: Set<String> = ["tag1", "tag2"]
    
    // When
    let meta1 = PulseMeta(
      debug: true,
      trace: trace_id,
      priority: .low,
      tags: tags
    )
    let meta2 = PulseMeta(
      debug: true,
      trace: trace_id,
      priority: .low,
      tags: tags
    )
    
    // Then
    #expect(meta1 == meta2)
  }
  
  @Test("Different PulseMeta instances compare as not equal")
  func different_pulse_meta_instances_compare_as_not_equal() throws {
    // Given
    let meta1 = PulseMeta(debug: true, priority: .high)
    let meta2 = PulseMeta(debug: false, priority: .low)
    
    // Then
    #expect(meta1 != meta2)
  }
}
