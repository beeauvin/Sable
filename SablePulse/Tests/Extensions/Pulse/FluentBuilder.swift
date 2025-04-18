// Copyright © 2025 Cassidy Spring. 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Testing
import SableFoundation

@testable import SablePulse

@Suite("SablePulse/Extensions: Pulse/Fluent")
struct PulseFluentTests {
  
  // MARK: - Test Data
  
  struct TestPulseData: Pulsable {
    let value: String
  }
  
  func create_test_data(value: String = "Test Value") -> TestPulseData {
    return TestPulseData(value: value)
  }
  
  func create_test_pulse(debug: Bool = false, tags: Set<String> = []) -> Pulse<TestPulseData> {
    let data = create_test_data()
    let meta = PulseMeta(debug: debug, tags: tags)
    return Pulse(id: UUID(), timestamp: Date(), data: data, meta: meta)
  }
  
  // MARK: - Debug Tests
  
  @Test("debug defaults to enabled")
  func debug_defaults_to_enabled() throws {
    // Given
    let pulse = create_test_pulse()
    
    // When
    let result = pulse.debug()
    
    // Then
    #expect(result.meta.debug == true)
  }
  
  @Test("debug accepts explicit values")
  func debug_accepts_explicit_values() throws {
    // Given
    let pulse = create_test_pulse()
    
    // When
    let enabled = pulse.debug(true)
    let disabled = pulse.debug(false)
    
    // Then
    #expect(enabled.meta.debug == true)
    #expect(disabled.meta.debug == false)
  }
  
  @Test("debug returns new pulse")
  func debug_returns_new_pulse() throws {
    // Given
    let original = create_test_pulse()
    
    // When
    let result = original.debug()
    
    // Then
    #expect(result != original) // Reference check not applicable to structs
    #expect(original.meta.debug == false) // Original unchanged
  }
  
  @Test("debug preserves other metadata")
  func debug_preserves_other_metadata() throws {
    // Given
    let custom_tags: Set<String> = ["test", "important"]
    let pulse = create_test_pulse(tags: custom_tags)
    
    // When
    let result = pulse.debug()
    
    // Then
    #expect(result.meta.tags == custom_tags)
  }
  
  // MARK: - Echoes Tests
  
  @Test("echoes sets echoes reference correctly")
  func echoes_sets_echoes_reference_correctly() throws {
    // Given
    let original = create_test_pulse()
    let pulse = create_test_pulse()
    
    // When
    let result = pulse.echoes(original)
    
    // Then
    #expect(result.meta.echoes != nil)
    #expect(result.meta.echoes?.id == original.id)
  }
  
  @Test("echoes copies trace id")
  func echoes_copies_trace_id() throws {
    // Given
    let original = create_test_pulse()
    let pulse = create_test_pulse()
    
    // When
    let result = pulse.echoes(original)
    
    // Then
    #expect(result.meta.trace == original.meta.trace)
  }
  
  @Test("echoes preserves other metadata")
  func echoes_preserves_other_metadata() throws {
    // Given
    let original = create_test_pulse()
    let pulse = create_test_pulse(debug: true, tags: ["test"])
    
    // When
    let result = pulse.echoes(original)
    
    // Then
    #expect(result.meta.debug == true)
    #expect(result.meta.tags.contains("test"))
  }
  
  @Test("echoes works with different data types")
  func echoes_works_with_different_data_types() throws {
    // Given
    struct OtherPulseData: Pulsable {
      let id: Int
    }
    
    let original = Pulse(OtherPulseData(id: 42))
    let pulse = create_test_pulse()
    
    // When
    let result = pulse.echoes(original)
    
    // Then
    #expect(result.meta.echoes != nil)
    #expect(result.meta.echoes?.id == original.id)
  }
  
  // MARK: - Source Tests
  
  @Test("from sets source correctly")
  func from_sets_source_correctly() throws {
    // Given
    struct TestSource: Representable {
      let id = UUID()
      let name = "Test Source"
    }
    
    let source = TestSource()
    let pulse = create_test_pulse()
    
    // When
    let result = pulse.from(source)
    
    // Then
    #expect(result.meta.source != nil)
    #expect(result.meta.source?.id == source.id)
    #expect(result.meta.source?.name == source.name)
  }
  
  @Test("from preserves other metadata")
  func from_preserves_other_metadata() throws {
    // Given
    struct TestSource: Representable {
      let id = UUID()
      let name = "Test Source"
    }
    
    let source = TestSource()
    let pulse = create_test_pulse(debug: true, tags: ["test"])
    
    // When
    let result = pulse.from(source)
    
    // Then
    #expect(result.meta.debug == true)
    #expect(result.meta.tags.contains("test"))
  }
  
  // MARK: - Priority Tests
  
  @Test("priority sets priority correctly")
  func priority_sets_priority_correctly() throws {
    // Given
    let pulse = create_test_pulse()
    
    // When
    let high_priority = pulse.priority(.high)
    let low_priority = pulse.priority(.low)
    
    // Then
    #expect(high_priority.priority == .high)
    #expect(low_priority.priority == .low)
  }
  
  @Test("priority preserves other metadata")
  func priority_preserves_other_metadata() throws {
    // Given
    let pulse = create_test_pulse(debug: true, tags: ["test"])
    
    // When
    let result = pulse.priority(.high)
    
    // Then
    #expect(result.meta.debug == true)
    #expect(result.meta.tags.contains("test"))
  }
  
  // MARK: - Tags Tests
  
  @Test("tagged adds tags by default")
  func tagged_adds_tags_by_default() throws {
    // Given
    let original_tags: Set<String> = ["original"]
    let pulse = create_test_pulse(tags: original_tags)
    
    // When
    let result = pulse.tagged("new", "extra")
    
    // Then
    #expect(result.meta.tags.contains("original"))
    #expect(result.meta.tags.contains("new"))
    #expect(result.meta.tags.contains("extra"))
    #expect(result.meta.tags.count == 3)
  }
  
  @Test("tagged with reset replaces existing tags")
  func tagged_with_reset_replaces_existing_tags() throws {
    // Given
    let original_tags: Set<String> = ["original", "test"]
    let pulse = create_test_pulse(tags: original_tags)
    
    // When
    let result = pulse.tagged("new", "extra", reset: true)
    
    // Then
    #expect(!result.meta.tags.contains("original"))
    #expect(!result.meta.tags.contains("test"))
    #expect(result.meta.tags.contains("new"))
    #expect(result.meta.tags.contains("extra"))
    #expect(result.meta.tags.count == 2)
  }
  
  @Test("tagged with empty params preserves tags")
  func tagged_with_empty_params_preserves_tags() throws {
    // Given
    let original_tags: Set<String> = ["original", "test"]
    let pulse = create_test_pulse(tags: original_tags)
    
    // When
    let result = pulse.tagged()
    
    // Then
    #expect(result.meta.tags == original_tags)
  }
  
  @Test("tagged with empty params and reset clears tags")
  func tagged_with_empty_params_and_reset_clears_tags() throws {
    // Given
    let original_tags: Set<String> = ["original", "test"]
    let pulse = create_test_pulse(tags: original_tags)
    
    // When
    let result = pulse.tagged(reset: true)
    
    // Then
    #expect(result.meta.tags.isEmpty)
  }
  
  // MARK: - Chaining Tests
  
  @Test("chaining multiple methods works correctly")
  func chaining_multiple_methods_works_correctly() throws {
    // Given
    struct TestSource: Representable {
      let id = UUID()
      let name = "Test Source"
    }
    
    let source = TestSource()
    let pulse = create_test_pulse()
    
    // When
    let result = pulse
      .debug()
      .priority(.high)
      .tagged("important", "critical")
      .from(source)
    
    // Then
    #expect(result.meta.debug == true)
    #expect(result.priority == .high)
    #expect(result.meta.tags.contains("important"))
    #expect(result.meta.tags.contains("critical"))
    #expect(result.meta.source?.id == source.id)
  }
  
  @Test("chaining order determines final state")
  func chaining_order_determines_final_state() throws {
    // Given
    let pulse = create_test_pulse()
    
    // When - debug(true) followed by debug(false)
    let result1 = pulse.debug(true).debug(false)
    
    // When - debug(false) followed by debug(true)
    let result2 = pulse.debug(false).debug(true)
    
    // Then
    #expect(result1.meta.debug == false)
    #expect(result2.meta.debug == true)
  }
  
  // MARK: - Immutability Tests
  
  @Test("original pulse remains unchanged after operations")
  func original_pulse_remains_unchanged_after_operations() throws {
    // Given
    let original_tags: Set<String> = ["original"]
    let pulse = create_test_pulse(tags: original_tags)
    
    // When - perform all operations
    let _ = pulse.debug()
    let _ = pulse.priority(.high)
    let _ = pulse.tagged("new")
    
    struct TestSource: Representable {
      let id = UUID()
      let name = "Test Source"
    }
    let _ = pulse.from(TestSource())
    
    let echo_source = create_test_pulse()
    let _ = pulse.echoes(echo_source)
    
    // Then - original should be unchanged
    #expect(pulse.meta.debug == false)
    #expect(pulse.priority == .medium) // Default value
    #expect(pulse.meta.tags == original_tags)
    #expect(pulse.meta.source == nil)
    #expect(pulse.meta.echoes == nil)
  }
}
