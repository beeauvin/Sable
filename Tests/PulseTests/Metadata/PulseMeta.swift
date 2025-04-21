// Copyright © 2025 Cassidy Spring (Bee). 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Testing
import Obsidian

@testable import Sable

@Suite("Sable/Pulse/Metadata: PulseMeta")
struct PulseMetaTests {
  
  // MARK: - Test Data
  
  struct TestRepresentable: Representable {
    let id = UUID()
    let name = "Test Source"
  }
  
  // MARK: - Protocol Conformance Tests
  
  @Test("conforms to Pulsable")
  func conforms_to_pulsable() throws {
    let is_pulsable = (PulseMeta.self as Any) is any Pulsable.Type
    #expect(is_pulsable)
  }
  
  // MARK: - Default Value Tests
  
  @Test("debug defaults to false")
  func debug_defaults_to_false() throws {
    let meta = PulseMeta()
    #expect(!meta.debug)
  }
  
  @Test("source defaults to nil")
  func source_defaults_to_nil() throws {
    let meta = PulseMeta()
    #expect(meta.source == nil)
  }
  
  @Test("echoes defaults to nil")
  func echoes_defaults_to_nil() throws {
    let meta = PulseMeta()
    #expect(meta.echoes == nil)
  }
  
  @Test("priority defaults to medium")
  func priority_defaults_to_medium() throws {
    let meta = PulseMeta()
    #expect(meta.priority == TaskPriority.medium.rawValue)
  }
  
  @Test("tags defaults to empty set")
  func tags_defaults_to_empty_set() throws {
    let meta = PulseMeta()
    #expect(meta.tags.isEmpty)
  }
  
  // MARK: - Custom Value Tests
  
  @Test("initializes with custom debug value")
  func initializes_with_custom_debug_value() throws {
    let meta = PulseMeta(debug: true)
    #expect(meta.debug)
  }
  
  @Test("initializes with custom trace value")
  func initializes_with_custom_trace_value() throws {
    let custom_trace = UUID()
    let meta = PulseMeta(trace: custom_trace)
    #expect(meta.trace == custom_trace)
  }
  
  @Test("initializes with custom source value")
  func initializes_with_custom_source_value() throws {
    let source_representable = TestRepresentable()
    let source = PulseSource.From(source: source_representable)
    
    let meta = PulseMeta(source: source)
    
    #expect(meta.source != nil)
    #expect(meta.source?.id == source.id)
    #expect(meta.source?.name == source.name)
  }
  
  @Test("initializes with custom echoes value")
  func initializes_with_custom_echoes_value() throws {
    let echo_representable = TestRepresentable()
    let echo = PulseSource.From(source: echo_representable)
    
    let meta = PulseMeta(echoes: echo)
    
    #expect(meta.echoes != nil)
    #expect(meta.echoes?.id == echo.id)
    #expect(meta.echoes?.name == echo.name)
  }
  
  @Test("initializes with custom priority value")
  func initializes_with_custom_priority_value() throws {
    let meta = PulseMeta(priority: .high)
    #expect(meta.priority == TaskPriority.high.rawValue)
  }
  
  @Test("initializes with custom tags value")
  func initializes_with_custom_tags_value() throws {
    let custom_tags: Set<String> = ["feature_flag", "beta", "testing"]
    
    let meta = PulseMeta(tags: custom_tags)
    
    #expect(meta.tags == custom_tags)
    #expect(meta.tags.count == 3)
  }
  
  // MARK: - Serialization Tests
  
  @Test("can be encoded to JSON")
  func can_be_encoded_to_json() throws {
    let meta = PulseMeta(
      debug: true,
      trace: UUID(),
      priority: .high,
      tags: ["test", "serialization"]
    )
    
    let encoder = JSONEncoder()
    
    // Should not throw
    let _ = try encoder.encode(meta)
  }
  
  @Test("can be decoded from JSON")
  func can_be_decoded_from_json() throws {
    let original = PulseMeta(
      debug: true,
      trace: UUID(),
      priority: .high,
      tags: ["test", "serialization"]
    )
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    let data = try encoder.encode(original)
    let decoded = try decoder.decode(PulseMeta.self, from: data)
    
    #expect(decoded.debug == original.debug)
    #expect(decoded.trace == original.trace)
    #expect(decoded.priority == original.priority)
    #expect(decoded.tags == original.tags)
  }
  
  @Test("preserves source when serialized")
  func preserves_source_when_serialized() throws {
    let source = PulseSource.From(source: TestRepresentable())
    let original = PulseMeta(source: source)
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    let data = try encoder.encode(original)
    let decoded = try decoder.decode(PulseMeta.self, from: data)
    
    #expect(decoded.source?.id == original.source?.id)
    #expect(decoded.source?.name == original.source?.name)
  }
  
  @Test("preserves echoes when serialized")
  func preserves_echoes_when_serialized() throws {
    let echo = PulseSource.From(source: TestRepresentable())
    let original = PulseMeta(echoes: echo)
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    let data = try encoder.encode(original)
    let decoded = try decoder.decode(PulseMeta.self, from: data)
    
    #expect(decoded.echoes?.id == original.echoes?.id)
    #expect(decoded.echoes?.name == original.echoes?.name)
  }
  
  // MARK: - Equality Tests
  
  @Test("instances with same properties are equal")
  func instances_with_same_properties_are_equal() throws {
    let trace_id = UUID()
    let tags: Set<String> = ["tag1", "tag2"]
    
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
    
    #expect(meta1 == meta2)
  }
  
  @Test("instances with different debug flags are not equal")
  func instances_with_different_debug_flags_are_not_equal() throws {
    let trace_id = UUID()
    
    let meta1 = PulseMeta(debug: true, trace: trace_id)
    let meta2 = PulseMeta(debug: false, trace: trace_id)
    
    #expect(meta1 != meta2)
  }
  
  @Test("instances with different trace ids are not equal")
  func instances_with_different_trace_ids_are_not_equal() throws {
    let meta1 = PulseMeta(trace: UUID())
    let meta2 = PulseMeta(trace: UUID())
    
    #expect(meta1 != meta2)
  }
  
  @Test("instances with different priorities are not equal")
  func instances_with_different_priorities_are_not_equal() throws {
    let meta1 = PulseMeta(priority: .high)
    let meta2 = PulseMeta(priority: .low)
    
    #expect(meta1 != meta2)
  }
  
  @Test("instances with different tags are not equal")
  func instances_with_different_tags_are_not_equal() throws {
    let meta1 = PulseMeta(tags: ["tag1"])
    let meta2 = PulseMeta(tags: ["tag2"])
    
    #expect(meta1 != meta2)
  }
  
  @Test("instances with different sources are not equal")
  func instances_with_different_sources_are_not_equal() throws {
    let source1 = PulseSource.From(source: TestRepresentable())
    let source2 = PulseSource.From(source: TestRepresentable())
    
    let meta1 = PulseMeta(source: source1)
    let meta2 = PulseMeta(source: source2)
    
    #expect(meta1 != meta2)
  }
  
  @Test("instances with different echoes are not equal")
  func instances_with_different_echoes_are_not_equal() throws {
    let echo1 = PulseSource.From(source: TestRepresentable())
    let echo2 = PulseSource.From(source: TestRepresentable())
    
    let meta1 = PulseMeta(echoes: echo1)
    let meta2 = PulseMeta(echoes: echo2)
    
    #expect(meta1 != meta2)
  }
}
