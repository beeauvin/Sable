// Copyright © 2025 Cassidy Spring. 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Testing
import SableFoundation

@testable import SablePulse

@Suite("SablePulse/Extensions/Pulse: Fluently")
struct PulseFluencyTests {
  
  // MARK: - Test Data
  
  struct TestPulseData: Pulsable {
    let value: String
  }
  
  struct AlternateTestData: Pulsable {
    let value: String
  }
  
  // MARK: - Static Fluently Tests
  
  @Test("Fluently(_:) preserves pulse identity")
  func fluently_static_preserves_pulse_identity() throws {
    // Given
    let original = Pulse(TestPulseData(value: "Original"))
    
    // When
    let updated = Pulse.Fluently(original)
    
    // Then
    #expect(updated.id == original.id)
    #expect(updated.timestamp == original.timestamp)
  }
  
  @Test("Fluently(_:) preserves data when not specified")
  func fluently_static_preserves_data_when_not_specified() throws {
    // Given
    let original_data = TestPulseData(value: "Original Data")
    let original = Pulse(original_data)
    
    // When
    let updated = Pulse.Fluently(original)
    
    // Then
    #expect(updated.data.value == original_data.value)
  }
  
  @Test("Fluently(_:) preserves metadata when not specified")
  func fluently_static_preserves_metadata_when_not_specified() throws {
    // Given
    let original = Pulse(TestPulseData(value: "Original"))
    
    // When
    let updated = Pulse.Fluently(original)
    
    // Then
    #expect(updated.meta.debug == original.meta.debug)
    #expect(updated.meta.trace == original.meta.trace)
    #expect(updated.meta.priority == original.meta.priority)
    #expect(updated.meta.tags == original.meta.tags)
  }
  
  @Test("Fluently(_:data:) updates data when specified")
  func fluently_static_updates_data_when_specified() throws {
    // Given
    let original_data = TestPulseData(value: "Original Data")
    let new_data = TestPulseData(value: "New Data")
    let original = Pulse(original_data)
    
    // When
    let updated = Pulse.Fluently(original, data: new_data)
    
    // Then
    #expect(updated.data.value == "New Data")
  }
  
  @Test("Fluently(_:meta:) updates metadata when specified")
  func fluently_static_updates_metadata_when_specified() throws {
    // Given
    let original = Pulse(TestPulseData(value: "Original"))
    let new_meta = PulseMeta(debug: true, priority: .high, tags: ["test"])
    
    // When
    let updated = Pulse.Fluently(original, meta: new_meta)
    
    // Then
    #expect(updated.meta.debug == true)
    #expect(updated.meta.priority == TaskPriority.high.rawValue)
    #expect(updated.meta.tags.contains("test"))
  }
  
  @Test("Fluently(_:data:meta:) updates both when specified")
  func fluently_static_updates_both_when_specified() throws {
    // Given
    let original_data = TestPulseData(value: "Original Data")
    let new_data = TestPulseData(value: "New Data")
    let original = Pulse(original_data)
    let new_meta = PulseMeta(debug: true, priority: .high)
    
    // When
    let updated = Pulse.Fluently(original, data: new_data, meta: new_meta)
    
    // Then
    #expect(updated.data.value == "New Data")
    #expect(updated.meta.debug == true)
    #expect(updated.meta.priority == TaskPriority.high.rawValue)
  }
  
  // MARK: - Instance Fluently Tests
  
  @Test("fluently() preserves pulse identity")
  func fluently_instance_preserves_pulse_identity() throws {
    // Given
    let original = Pulse(TestPulseData(value: "Original"))
    
    // When
    let updated = original.fluently()
    
    // Then
    #expect(updated.id == original.id)
    #expect(updated.timestamp == original.timestamp)
  }
  
  @Test("fluently() preserves data when not specified")
  func fluently_instance_preserves_data_when_not_specified() throws {
    // Given
    let original_data = TestPulseData(value: "Original Data")
    let original = Pulse(original_data)
    
    // When
    let updated = original.fluently()
    
    // Then
    #expect(updated.data.value == original_data.value)
  }
  
  @Test("fluently() preserves metadata when not specified")
  func fluently_instance_preserves_metadata_when_not_specified() throws {
    // Given
    let original = Pulse(TestPulseData(value: "Original"))
    
    // When
    let updated = original.fluently()
    
    // Then
    #expect(updated.meta.debug == original.meta.debug)
    #expect(updated.meta.trace == original.meta.trace)
    #expect(updated.meta.priority == original.meta.priority)
    #expect(updated.meta.tags == original.meta.tags)
  }
  
  @Test("fluently(data:) updates data when specified")
  func fluently_instance_updates_data_when_specified() throws {
    // Given
    let original_data = TestPulseData(value: "Original Data")
    let new_data = TestPulseData(value: "New Data")
    let original = Pulse(original_data)
    
    // When
    let updated = original.fluently(data: new_data)
    
    // Then
    #expect(updated.data.value == "New Data")
  }
  
  @Test("fluently(meta:) updates metadata when specified")
  func fluently_instance_updates_metadata_when_specified() throws {
    // Given
    let original = Pulse(TestPulseData(value: "Original"))
    let new_meta = PulseMeta(debug: true, priority: .high, tags: ["test"])
    
    // When
    let updated = original.fluently(meta: new_meta)
    
    // Then
    #expect(updated.meta.debug == true)
    #expect(updated.meta.priority == TaskPriority.high.rawValue)
    #expect(updated.meta.tags.contains("test"))
  }
  
  @Test("fluently(data:meta:) updates both when specified")
  func fluently_instance_updates_both_when_specified() throws {
    // Given
    let original_data = TestPulseData(value: "Original Data")
    let new_data = TestPulseData(value: "New Data")
    let original = Pulse(original_data)
    let new_meta = PulseMeta(debug: true, priority: .high)
    
    // When
    let updated = original.fluently(data: new_data, meta: new_meta)
    
    // Then
    #expect(updated.data.value == "New Data")
    #expect(updated.meta.debug == true)
    #expect(updated.meta.priority == TaskPriority.high.rawValue)
  }
  
  // MARK: - Equality Tests
  
  @Test("fluently with no changes creates equal pulse")
  func fluently_with_no_changes_creates_equal_pulse() throws {
    // Given
    let original = Pulse(TestPulseData(value: "Original"))
    
    // When
    let updated = original.fluently()
    
    // Then
    #expect(updated == original)
  }
  
  @Test("fluently with changes creates non-equal pulse")
  func fluently_with_changes_creates_non_equal_pulse() throws {
    // Given
    let original = Pulse(TestPulseData(value: "Original"))
    
    // When
    let updated = original.fluently(data: TestPulseData(value: "Modified"))
    
    // Then
    #expect(updated != original)
  }
}
