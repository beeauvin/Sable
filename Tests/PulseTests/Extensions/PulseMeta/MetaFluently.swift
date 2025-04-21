// Copyright © 2025 Cassidy Spring. 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Testing
import Obsidian

@testable import Sable

@Suite("Sable/Pulse/Extensions: PulseMeta/Fluent")
struct PulseMetaFluentTests {
  
  // MARK: - Test Data
  
  struct TestRepresentable: Representable {
    let id = UUID()
    let name = "Test Source"
  }
  
  // MARK: - Static Fluently Method Tests
  
  @Test("Fluently preserves trace when not specified")
  func fluently_preserves_trace_when_not_specified() throws {
    let original = PulseMeta()
    let updated = PulseMeta.Fluently(original, debug: true)
    
    #expect(updated.trace == original.trace)
  }
  
  @Test("Fluently preserves source when not specified")
  func fluently_preserves_source_when_not_specified() throws {
    let original = PulseMeta()
    let updated = PulseMeta.Fluently(original, debug: true)
    
    #expect(updated.source == original.source)
  }
  
  @Test("Fluently preserves echoes when not specified")
  func fluently_preserves_echoes_when_not_specified() throws {
    let original = PulseMeta()
    let updated = PulseMeta.Fluently(original, debug: true)
    
    #expect(updated.echoes == original.echoes)
  }
  
  @Test("Fluently preserves priority when not specified")
  func fluently_preserves_priority_when_not_specified() throws {
    let original = PulseMeta()
    let updated = PulseMeta.Fluently(original, debug: true)
    
    #expect(updated.priority == original.priority)
  }
  
  @Test("Fluently preserves tags when not specified")
  func fluently_preserves_tags_when_not_specified() throws {
    let original = PulseMeta()
    let updated = PulseMeta.Fluently(original, debug: true)
    
    #expect(updated.tags == original.tags)
  }
  
  @Test("Fluently updates debug flag")
  func fluently_updates_debug_flag() throws {
    let original = PulseMeta(debug: false)
    let updated = PulseMeta.Fluently(original, debug: true)
    
    #expect(original.debug == false)
    #expect(updated.debug == true)
  }
  
  @Test("Fluently updates trace")
  func fluently_updates_trace() throws {
    let original = PulseMeta()
    let new_trace = UUID()
    
    let updated = PulseMeta.Fluently(original, trace: new_trace)
    
    #expect(updated.trace == new_trace)
    #expect(updated.trace != original.trace)
  }
  
  @Test("Fluently updates source")
  func fluently_updates_source() throws {
    let original = PulseMeta()
    let source = PulseSource.From(source: TestRepresentable())
    
    let updated = PulseMeta.Fluently(original, source: source)
    
    #expect(updated.source?.id == source.id)
    #expect(updated.source?.name == source.name)
  }
  
  @Test("Fluently updates echoes")
  func fluently_updates_echoes() throws {
    let original = PulseMeta()
    let echo = PulseSource.From(source: TestRepresentable())
    
    let updated = PulseMeta.Fluently(original, echoes: echo)
    
    #expect(updated.echoes?.id == echo.id)
    #expect(updated.echoes?.name == echo.name)
  }
  
  @Test("Fluently updates priority")
  func fluently_updates_priority() throws {
    let original = PulseMeta(priority: .low)
    let updated = PulseMeta.Fluently(original, priority: .high)
    
    #expect(updated.priority == TaskPriority.high.rawValue)
    #expect(updated.priority != original.priority)
  }
  
  @Test("Fluently updates tags")
  func fluently_updates_tags() throws {
    let original = PulseMeta()
    let new_tags: Set<String> = ["test", "fluent"]
    
    let updated = PulseMeta.Fluently(original, tags: new_tags)
    
    #expect(updated.tags == new_tags)
    #expect(updated.tags != original.tags)
  }
  
  @Test("Fluently replaces tags with empty set when specified")
  func fluently_replaces_tags_with_empty_set_when_specified() throws {
    let original = PulseMeta(tags: ["original"])
    let empty_tags: Set<String> = []
    
    let updated = PulseMeta.Fluently(original, tags: empty_tags)
    
    #expect(updated.tags.isEmpty)
    #expect(updated.tags != original.tags)
  }
  
  // MARK: - Instance Fluently Method Tests
  
  @Test("instance fluently forwards to static Fluently")
  func instance_fluently_forwards_to_static_fluently() throws {
    let original = PulseMeta()
    let debug = true
    
    let static_result = PulseMeta.Fluently(original, debug: debug)
    let instance_result = original.fluently(debug: debug)
    
    #expect(static_result.debug == instance_result.debug)
    #expect(static_result.trace == instance_result.trace)
    #expect(static_result.source == instance_result.source)
    #expect(static_result.echoes == instance_result.echoes)
    #expect(static_result.priority == instance_result.priority)
    #expect(static_result.tags == instance_result.tags)
  }
  
  @Test("instance fluently can update debug flag")
  func instance_fluently_can_update_debug_flag() throws {
    let original = PulseMeta(debug: false)
    let result = original.fluently(debug: true)
    
    #expect(result.debug == true)
    #expect(original.debug == false)
  }
  
  @Test("instance fluently can update trace")
  func instance_fluently_can_update_trace() throws {
    let original = PulseMeta()
    let new_trace = UUID()
    
    let result = original.fluently(trace: new_trace)
    
    #expect(result.trace == new_trace)
    #expect(result.trace != original.trace)
  }
  
  @Test("instance fluently can update priority")
  func instance_fluently_can_update_priority() throws {
    let original = PulseMeta(priority: .low)
    let result = original.fluently(priority: .high)
    
    #expect(result.priority == TaskPriority.high.rawValue)
    #expect(result.priority != original.priority)
  }
  
  @Test("instance fluently enables method chaining")
  func instance_fluently_enables_method_chaining() throws {
    let original = PulseMeta()
    
    let result = original
      .fluently(debug: true)
      .fluently(priority: .high)
    
    #expect(result.debug == true)
    #expect(result.priority == TaskPriority.high.rawValue)
  }
  
  @Test("instance fluently maintains immutability")
  func instance_fluently_maintains_immutability() throws {
    let original = PulseMeta(debug: false, priority: .low)
    
    let _ = original.fluently(debug: true, priority: .high)
    
    #expect(original.debug == false)
    #expect(original.priority == TaskPriority.low.rawValue)
  }
  
  @Test("instance fluently updates multiple properties in one call")
  func instance_fluently_updates_multiple_properties() throws {
    let original = PulseMeta()
    let new_trace = UUID()
    
    let updated = original.fluently(
      debug: true,
      trace: new_trace,
      priority: .high
    )
    
    #expect(updated.debug == true)
    #expect(updated.trace == new_trace)
    #expect(updated.priority == TaskPriority.high.rawValue)
  }
}
