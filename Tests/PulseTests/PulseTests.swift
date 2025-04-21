// Copyright © 2025 Cassidy Spring (Bee). 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Testing
import Obsidian

@testable import Sable

@Suite("Sable/Pulse/Core: Pulse")
struct PulseTests {
  
  // MARK: - Test Data
  
  struct TestPulseData: Pulsable {
    let value: String
  }
  
  func create_test_data() -> TestPulseData {
    return TestPulseData(value: "Test Value")
  }
  
  // MARK: - Protocol Conformance Tests
  
  @Test("conforms to Pulsable")
  func conforms_to_pulsable() throws {
    let is_pulsable = (Pulse<TestPulseData>.self as Any) is any Pulsable.Type
    #expect(is_pulsable)
  }
  
  @Test("conforms to Representable")
  func conforms_to_representable() throws {
    let is_representable = (Pulse<TestPulseData>.self as Any) is any Representable.Type
    #expect(is_representable)
  }
  
  // MARK: - Initialization Tests
  
  @Test("initialization creates pulse with provided data")
  func initialization_creates_pulse_with_provided_data() throws {
    let test_data = create_test_data()
    let pulse = Pulse(test_data)
    
    #expect(pulse.data.value == "Test Value")
  }
  
  @Test("initialization assigns unique id")
  func initialization_assigns_unique_id() throws {
    let test_data = create_test_data()
    
    let pulse1 = Pulse(test_data)
    let pulse2 = Pulse(test_data)
    
    #expect(pulse1.id != pulse2.id)
  }
  
  @Test("initialization sets timestamp to current time")
  func initialization_sets_timestamp_to_current_time() throws {
    let before = Date()
    let pulse = Pulse(create_test_data())
    let after = Date()
    
    #expect(pulse.timestamp >= before)
    #expect(pulse.timestamp <= after)
  }
  
  @Test("initialization creates default metadata with debug disabled")
  func initialization_creates_default_metadata_with_debug_disabled() throws {
    let pulse = Pulse(create_test_data())
    #expect(!pulse.meta.debug)
  }
  
  @Test("initialization creates default metadata with nil source")
  func initialization_creates_default_metadata_with_nil_source() throws {
    let pulse = Pulse(create_test_data())
    #expect(pulse.meta.source == nil)
  }
  
  @Test("initialization creates default metadata with nil echoes")
  func initialization_creates_default_metadata_with_nil_echoes() throws {
    let pulse = Pulse(create_test_data())
    #expect(pulse.meta.echoes == nil)
  }
  
  @Test("initialization creates default metadata with medium priority")
  func initialization_creates_default_metadata_with_medium_priority() throws {
    let pulse = Pulse(create_test_data())
    #expect(pulse.meta.priority == TaskPriority.medium.rawValue)
  }
  
  @Test("initialization creates default metadata with empty tags")
  func initialization_creates_default_metadata_with_empty_tags() throws {
    let pulse = Pulse(create_test_data())
    #expect(pulse.meta.tags.isEmpty)
  }
  
  // MARK: - Property Tests
  
  @Test("name returns formatted type name")
  func name_returns_formatted_type_name() throws {
    let pulse = Pulse(create_test_data())
    
    #expect(pulse.name == "Pulse:TestPulseData")
  }
  
  @Test("priority returns strongly-typed TaskPriority")
  func priority_returns_strongly_typed_task_priority() throws {
    let pulse = Pulse(create_test_data())
    
    #expect(pulse.priority == .medium)
    #expect(type(of: pulse.priority) == TaskPriority.self)
  }
  
  @Test("description combines name and id")
  func description_combines_name_and_id() throws {
    let pulse = Pulse(create_test_data())
    
    #expect(pulse.description == "\(pulse.name):\(pulse.id)")
  }
  
  // MARK: - Serialization Tests
  
  @Test("can be encoded to JSON")
  func can_be_encoded_to_json() throws {
    let pulse = Pulse(create_test_data())
    let encoder = JSONEncoder()
    
    // Should not throw
    let _ = try encoder.encode(pulse)
  }
  
  @Test("can be decoded from JSON")
  func can_be_decoded_from_json() throws {
    let original = Pulse(create_test_data())
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    let data = try encoder.encode(original)
    let decoded = try decoder.decode(Pulse<TestPulseData>.self, from: data)
    
    #expect(decoded.id == original.id)
    #expect(decoded.timestamp.timeIntervalSince1970 == original.timestamp.timeIntervalSince1970)
    #expect(decoded.data.value == original.data.value)
  }
  
  @Test("preserves metadata debug flag when serialized")
  func preserves_metadata_debug_flag_when_serialized() throws {
    // Create a pulse with non-default metadata for testing
    let original = Pulse(create_test_data())
    let meta = PulseMeta(debug: true)
    let modified = Pulse(id: original.id, timestamp: original.timestamp, data: original.data, meta: meta)
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    let data = try encoder.encode(modified)
    let decoded = try decoder.decode(Pulse<TestPulseData>.self, from: data)
    
    #expect(decoded.meta.debug == true)
  }
  
  @Test("preserves metadata priority when serialized")
  func preserves_metadata_priority_when_serialized() throws {
    // Create a pulse with non-default metadata for testing
    let original = Pulse(create_test_data())
    let meta = PulseMeta(priority: .high)
    let modified = Pulse(id: original.id, timestamp: original.timestamp, data: original.data, meta: meta)
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    let data = try encoder.encode(modified)
    let decoded = try decoder.decode(Pulse<TestPulseData>.self, from: data)
    
    #expect(decoded.meta.priority == TaskPriority.high.rawValue)
  }
  
  @Test("preserves metadata tags when serialized")
  func preserves_metadata_tags_when_serialized() throws {
    // Create a pulse with non-default metadata for testing
    let original = Pulse(create_test_data())
    let meta = PulseMeta(tags: ["test", "serialization"])
    let modified = Pulse(id: original.id, timestamp: original.timestamp, data: original.data, meta: meta)
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    let data = try encoder.encode(modified)
    let decoded = try decoder.decode(Pulse<TestPulseData>.self, from: data)
    
    #expect(decoded.meta.tags.contains("test"))
    #expect(decoded.meta.tags.contains("serialization"))
    #expect(decoded.meta.tags.count == 2)
  }
  
  // MARK: - Equality Tests
  
  @Test("instances with same properties are equal")
  func instances_with_same_properties_are_equal() throws {
    // Create two pulse instances with identical properties
    let id = UUID()
    let timestamp = Date()
    let data = create_test_data()
    let meta = PulseMeta()
    
    let pulse1 = Pulse(id: id, timestamp: timestamp, data: data, meta: meta)
    let pulse2 = Pulse(id: id, timestamp: timestamp, data: data, meta: meta)
    
    #expect(pulse1 == pulse2)
  }
  
  @Test("instances with different ids are not equal")
  func instances_with_different_ids_are_not_equal() throws {
    let timestamp = Date()
    let data = create_test_data()
    let meta = PulseMeta()
    
    let pulse1 = Pulse(id: UUID(), timestamp: timestamp, data: data, meta: meta)
    let pulse2 = Pulse(id: UUID(), timestamp: timestamp, data: data, meta: meta)
    
    #expect(pulse1 != pulse2)
  }
  
  @Test("instances with different timestamps are not equal")
  func instances_with_different_timestamps_are_not_equal() throws {
    let id = UUID()
    let data = create_test_data()
    let meta = PulseMeta()
    
    let pulse1 = Pulse(id: id, timestamp: Date(), data: data, meta: meta)
    let pulse2 = Pulse(id: id, timestamp: Date(timeIntervalSinceNow: 100), data: data, meta: meta)
    
    #expect(pulse1 != pulse2)
  }
  
  @Test("instances with different data are not equal")
  func instances_with_different_data_are_not_equal() throws {
    let id = UUID()
    let timestamp = Date()
    let meta = PulseMeta()
    
    let pulse1 = Pulse(id: id, timestamp: timestamp, data: TestPulseData(value: "Value 1"), meta: meta)
    let pulse2 = Pulse(id: id, timestamp: timestamp, data: TestPulseData(value: "Value 2"), meta: meta)
    
    #expect(pulse1 != pulse2)
  }
  
  @Test("instances with different metadata are not equal")
  func instances_with_different_metadata_are_not_equal() throws {
    let id = UUID()
    let timestamp = Date()
    let data = create_test_data()
    
    let pulse1 = Pulse(id: id, timestamp: timestamp, data: data, meta: PulseMeta(debug: true))
    let pulse2 = Pulse(id: id, timestamp: timestamp, data: data, meta: PulseMeta(debug: false))
    
    #expect(pulse1 != pulse2)
  }
}
