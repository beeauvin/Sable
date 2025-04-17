// Copyright © 2025 Cassidy Spring. 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Testing
import SableFoundation

@testable import SablePulse

@Suite("SablePulse/Extensions: Pulse/Fluently")
struct PulseFluencyTests {
  
  // MARK: - Test Data
  
  struct TestPulseData: Pulsable {
    let value: String
  }
  
  func create_test_data(value: String = "Original Data") -> TestPulseData {
    return TestPulseData(value: value)
  }
  
  // MARK: - Static Fluently Tests
  
  @Test("static Fluently preserves pulse id")
  func static_fluently_preserves_pulse_id() throws {
    let original = Pulse(create_test_data())
    let updated = Pulse.Fluently(original)
    
    #expect(updated.id == original.id)
  }
  
  @Test("static Fluently preserves pulse timestamp")
  func static_fluently_preserves_pulse_timestamp() throws {
    let original = Pulse(create_test_data())
    let updated = Pulse.Fluently(original)
    
    #expect(updated.timestamp == original.timestamp)
  }
  
  @Test("static Fluently preserves data when not specified")
  func static_fluently_preserves_data_when_not_specified() throws {
    let original_data = create_test_data()
    let original = Pulse(original_data)
    
    let updated = Pulse.Fluently(original)
    
    #expect(updated.data.value == original_data.value)
  }
  
  @Test("static Fluently preserves metadata when not specified")
  func static_fluently_preserves_metadata_when_not_specified() throws {
    let original = Pulse(create_test_data())
    
    let updated = Pulse.Fluently(original)
    
    #expect(updated.meta.debug == original.meta.debug)
    #expect(updated.meta.trace == original.meta.trace)
    #expect(updated.meta.priority == original.meta.priority)
    #expect(updated.meta.tags == original.meta.tags)
  }
  
  @Test("static Fluently updates data when specified")
  func static_fluently_updates_data_when_specified() throws {
    let original_data = create_test_data(value: "Original Data")
    let new_data = create_test_data(value: "New Data")
    let original = Pulse(original_data)
    
    let updated = Pulse.Fluently(original, data: new_data)
    
    #expect(updated.data.value == "New Data")
  }
  
  @Test("static Fluently updates metadata when specified")
  func static_fluently_updates_metadata_when_specified() throws {
    let original = Pulse(create_test_data())
    let new_meta = PulseMeta(debug: true, priority: .high, tags: ["test"])
    
    let updated = Pulse.Fluently(original, meta: new_meta)
    
    #expect(updated.meta.debug == true)
    #expect(updated.meta.priority == TaskPriority.high.rawValue)
    #expect(updated.meta.tags.contains("test"))
  }
  
  @Test("static Fluently updates both data and metadata when specified")
  func static_fluently_updates_both_when_specified() throws {
    let original_data = create_test_data(value: "Original Data")
    let new_data = create_test_data(value: "New Data")
    let original = Pulse(original_data)
    let new_meta = PulseMeta(debug: true, priority: .high)
    
    let updated = Pulse.Fluently(original, data: new_data, meta: new_meta)
    
    #expect(updated.data.value == "New Data")
    #expect(updated.meta.debug == true)
    #expect(updated.meta.priority == TaskPriority.high.rawValue)
  }
  
  // MARK: - Instance Fluently Tests
  
  @Test("instance fluently preserves pulse id")
  func instance_fluently_preserves_pulse_id() throws {
    let original = Pulse(create_test_data())
    let updated = original.fluently()
    
    #expect(updated.id == original.id)
  }
  
  @Test("instance fluently preserves pulse timestamp")
  func instance_fluently_preserves_pulse_timestamp() throws {
    let original = Pulse(create_test_data())
    let updated = original.fluently()
    
    #expect(updated.timestamp == original.timestamp)
  }
  
  @Test("instance fluently preserves data when not specified")
  func instance_fluently_preserves_data_when_not_specified() throws {
    let original_data = create_test_data()
    let original = Pulse(original_data)
    
    let updated = original.fluently()
    
    #expect(updated.data.value == original_data.value)
  }
  
  @Test("instance fluently preserves metadata when not specified")
  func instance_fluently_preserves_metadata_when_not_specified() throws {
    let original = Pulse(create_test_data())
    
    let updated = original.fluently()
    
    #expect(updated.meta.debug == original.meta.debug)
    #expect(updated.meta.trace == original.meta.trace)
    #expect(updated.meta.priority == original.meta.priority)
    #expect(updated.meta.tags == original.meta.tags)
  }
  
  @Test("instance fluently updates data when specified")
  func instance_fluently_updates_data_when_specified() throws {
    let original_data = create_test_data(value: "Original Data")
    let new_data = create_test_data(value: "New Data")
    let original = Pulse(original_data)
    
    let updated = original.fluently(data: new_data)
    
    #expect(updated.data.value == "New Data")
  }
  
  @Test("instance fluently updates metadata when specified")
  func instance_fluently_updates_metadata_when_specified() throws {
    let original = Pulse(create_test_data())
    let new_meta = PulseMeta(debug: true, priority: .high, tags: ["test"])
    
    let updated = original.fluently(meta: new_meta)
    
    #expect(updated.meta.debug == true)
    #expect(updated.meta.priority == TaskPriority.high.rawValue)
    #expect(updated.meta.tags.contains("test"))
  }
  
  @Test("instance fluently updates both data and metadata when specified")
  func instance_fluently_updates_both_when_specified() throws {
    let original_data = create_test_data(value: "Original Data")
    let new_data = create_test_data(value: "New Data")
    let original = Pulse(original_data)
    let new_meta = PulseMeta(debug: true, priority: .high)
    
    let updated = original.fluently(data: new_data, meta: new_meta)
    
    #expect(updated.data.value == "New Data")
    #expect(updated.meta.debug == true)
    #expect(updated.meta.priority == TaskPriority.high.rawValue)
  }
  
  // MARK: - Instance vs Static Tests
  
  @Test("instance fluently forwards to static Fluently")
  func instance_fluently_forwards_to_static_fluently() throws {
    let original = Pulse(create_test_data())
    let new_data = create_test_data(value: "New Data")
    let new_meta = PulseMeta(debug: true)
    
    let static_result = Pulse.Fluently(original, data: new_data, meta: new_meta)
    let instance_result = original.fluently(data: new_data, meta: new_meta)
    
    #expect(instance_result.id == static_result.id)
    #expect(instance_result.timestamp == static_result.timestamp)
    #expect(instance_result.data.value == static_result.data.value)
    #expect(instance_result.meta.debug == static_result.meta.debug)
  }
  
  // MARK: - Immutability Tests
  
  @Test("fluently maintains immutability of original pulse")
  func fluently_maintains_immutability_of_original_pulse() throws {
    let original_data = create_test_data(value: "Original Data")
    let original = Pulse(original_data)
    
    let _ = original.fluently(
      data: create_test_data(value: "New Data"),
      meta: PulseMeta(debug: true)
    )
    
    #expect(original.data.value == "Original Data")
    #expect(!original.meta.debug)
  }
  
  // MARK: - Equality Tests
  
  @Test("fluently with no changes creates equal pulse")
  func fluently_with_no_changes_creates_equal_pulse() throws {
    let original = Pulse(create_test_data())
    let updated = original.fluently()
    
    #expect(updated == original)
  }
  
  @Test("fluently with data change creates non-equal pulse")
  func fluently_with_data_change_creates_non_equal_pulse() throws {
    let original = Pulse(create_test_data(value: "Original"))
    let updated = original.fluently(data: create_test_data(value: "Modified"))
    
    #expect(updated != original)
  }
  
  @Test("fluently with metadata change creates non-equal pulse")
  func fluently_with_metadata_change_creates_non_equal_pulse() throws {
    let original = Pulse(create_test_data())
    let updated = original.fluently(meta: PulseMeta(debug: true))
    
    #expect(updated != original)
  }
}
