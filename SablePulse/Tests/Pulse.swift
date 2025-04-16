// Copyright © 2025 Cassidy Spring. 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Testing
import SableFoundation

@testable import SablePulse

@Suite("SablePulse/Pulse")
struct PulseTests {
  
  // MARK: - Test Data
  
  struct TestPulseData: Pulsable {
    let value: String
  }
  
  // MARK: - Protocol Conformance Tests
  
  @Test("Pulse conforms to Pulsable")
  func pulse_conforms_to_pulsable() throws {
    // Given
    let is_pulsable = (Pulse<TestPulseData>.self as Any) is any Pulsable.Type
    
    // Then
    #expect(is_pulsable)
  }
  
  @Test("Pulse conforms to Representable")
  func pulse_conforms_to_representable() throws {
    // Given
    let is_representable = (Pulse<TestPulseData>.self as Any) is any Representable.Type
    
    // Then
    #expect(is_representable)
  }
  
  // MARK: - Initialization Tests
  
  @Test("init(_:) creates pulse with provided data")
  func init_creates_pulse_with_provided_data() throws {
    // Given
    let test_data = TestPulseData(value: "Test Value")
    
    // When
    let pulse = Pulse(test_data)
    
    // Then
    #expect(pulse.data.value == "Test Value")
  }
  
  @Test("init(_:) creates pulse with default metadata")
  func init_creates_pulse_with_default_metadata() throws {
    // Given
    let test_data = TestPulseData(value: "Test Value")
    
    // When
    let pulse = Pulse(test_data)
    
    // Then
    #expect(!pulse.meta.debug, "Debug should default to false")
    #expect(pulse.meta.source == .none, "Source should default to none")
    #expect(pulse.meta.echoes == .none, "Echoes should default to none")
    #expect(pulse.meta.priority == TaskPriority.medium.rawValue, "Priority should default to medium")
    #expect(pulse.meta.tags.isEmpty, "Tags should default to empty set")
  }
  
  @Test("init(_:) creates pulse with unique id")
  func init_creates_pulse_with_unique_id() throws {
    // Given
    let test_data = TestPulseData(value: "Test Value")
    
    // When
    let pulse1 = Pulse(test_data)
    let pulse2 = Pulse(test_data)
    
    // Then
    #expect(pulse1.id != pulse2.id, "Each pulse should have a unique ID")
  }
  
  @Test("init(_:) creates pulse with current timestamp")
  func init_creates_pulse_with_current_timestamp() throws {
    // Given
    let before = Date()
    
    // When
    let pulse = Pulse(TestPulseData(value: "Test Value"))
    let after = Date()
    
    // Then
    #expect(pulse.timestamp >= before, "Timestamp should be after or equal to before creation")
    #expect(pulse.timestamp <= after, "Timestamp should be before or equal to after creation")
  }
  
  // MARK: - Property Tests
  
  @Test("name property returns formatted type name")
  func name_property_returns_formatted_type_name() throws {
    // Given
    let pulse = Pulse(TestPulseData(value: "Test Value"))
    
    // When
    let name = pulse.name
    
    // Then
    #expect(name == "Pulse:TestPulseData")
  }
  
  @Test("priority property returns strongly-typed TaskPriority")
  func priority_property_returns_strongly_typed_task_priority() throws {
    // Given
    let test_data = TestPulseData(value: "Test Value")
    let pulse = Pulse(test_data)
    
    // When
    let priority = pulse.priority
    
    // Then
    #expect(priority == .medium, "Default priority should be medium")
    #expect(type(of: priority) == TaskPriority.self, "Priority should be TaskPriority type")
  }
  
  @Test("description combines name and id")
  func description_combines_name_and_id() throws {
    // Given
    let pulse = Pulse(TestPulseData(value: "Test Value"))
    
    // When
    let description = pulse.description
    
    // Then
    #expect(description == "\(pulse.name):\(pulse.id)")
  }
  
  // MARK: - Fluent Builder Tests
  
  @Test("Fluently(_:meta:) creates new pulse with same id and timestamp")
  func fluently_creates_new_pulse_with_same_id_and_timestamp() throws {
    // Given
    let original = Pulse(TestPulseData(value: "Original"))
    let new_meta = PulseMeta(debug: true)
    
    // When
    let modified = Pulse.Fluently(original, meta: new_meta)
    
    // Then
    #expect(modified.id == original.id, "ID should remain the same")
    #expect(modified.timestamp == original.timestamp, "Timestamp should remain the same")
  }
  
  @Test("Fluently(_:meta:) creates new pulse with same data")
  func fluently_creates_new_pulse_with_same_data() throws {
    // Given
    let original_data = TestPulseData(value: "Original")
    let original = Pulse(original_data)
    let new_meta = PulseMeta(debug: true)
    
    // When
    let modified = Pulse.Fluently(original, meta: new_meta)
    
    // Then
    #expect(modified.data.value == original.data.value, "Data should remain the same")
  }
  
  @Test("Fluently(_:meta:) creates new pulse with updated metadata")
  func fluently_creates_new_pulse_with_updated_metadata() throws {
    // Given
    let original = Pulse(TestPulseData(value: "Original"))
    let new_meta = PulseMeta(debug: true, priority: .high, tags: ["test"])
    
    // When
    let modified = Pulse.Fluently(original, meta: new_meta)
    
    // Then
    #expect(modified.meta.debug == true, "Debug flag should be updated")
    #expect(modified.meta.priority == TaskPriority.high.rawValue, "Priority should be updated")
    #expect(modified.meta.tags.contains("test"), "Tags should be updated")
  }
  
  // MARK: - Serialization Tests
  
  @Test("Pulse can be encoded and decoded")
  func pulse_can_be_encoded_and_decoded() throws {
    // Given
    let original = Pulse(TestPulseData(value: "Test Value"))
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    // When
    let data = try encoder.encode(original)
    let decoded = try decoder.decode(Pulse<TestPulseData>.self, from: data)
    
    // Then
    #expect(decoded.id == original.id)
    #expect(decoded.timestamp.timeIntervalSince1970 == original.timestamp.timeIntervalSince1970)
    #expect(decoded.data.value == original.data.value)
    #expect(decoded.meta.debug == original.meta.debug)
    #expect(decoded.meta.priority == original.meta.priority)
    #expect(decoded.meta.tags == original.meta.tags)
  }
  
  // MARK: - Equality Tests
  
  @Test("Equal Pulse instances compare as equal")
  func equal_pulse_instances_compare_as_equal() throws {
    // Given
    let data = TestPulseData(value: "Test")
    
    // When
    let pulse1 = Pulse(data)
    let pulse2 = Pulse.Fluently(pulse1, meta: pulse1.meta)
    
    // Then
    #expect(pulse1 == pulse2)
  }
  
  @Test("Different Pulse instances compare as not equal")
  func different_pulse_instances_compare_as_not_equal() throws {
    // Given
    let pulse1 = Pulse(TestPulseData(value: "Test 1"))
    let pulse2 = Pulse(TestPulseData(value: "Test 2"))
    
    // Then
    #expect(pulse1 != pulse2)
  }
}
