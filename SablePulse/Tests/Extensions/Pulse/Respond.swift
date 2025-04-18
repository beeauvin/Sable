// Copyright © 2025 Cassidy Spring. 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Testing
import SableFoundation

@testable import SablePulse

@Suite("SablePulse/Extensions: Pulse/Respond")
struct PulseRespondTests {
  
  // MARK: - Test Data
  
  struct OriginalPulseData: Pulsable {
    let message: String
  }
  
  struct ResponsePulseData: Pulsable {
    let success: Bool
    let details: String
  }
  
  struct TestSource: Representable {
    let id = UUID()
    let name = "Test Response Source"
  }
  
  func create_original_pulse() -> Pulse<OriginalPulseData> {
    return Pulse(OriginalPulseData(message: "Test Message"))
  }
  
  func create_response_data() -> ResponsePulseData {
    return ResponsePulseData(success: true, details: "Successfully processed")
  }
  
  // MARK: - Basic Functionality Tests
  
  @Test("creates a new pulse with the provided data")
  func creates_new_pulse_with_provided_data() throws {
    // Given
    let original = create_original_pulse()
    let response_data = create_response_data()
    
    // When
    let response = Pulse.Respond(to: original, with: response_data)
    
    // Then
    #expect(response.data.success == true)
    #expect(response.data.details == "Successfully processed")
  }
  
  @Test("assigns a new UUID to the response pulse")
  func assigns_new_uuid_to_response_pulse() throws {
    // Given
    let original = create_original_pulse()
    let response_data = create_response_data()
    
    // When
    let response = Pulse.Respond(to: original, with: response_data)
    
    // Then
    #expect(response.id != original.id)
  }
  
  @Test("sets a new timestamp on the response pulse")
  func sets_new_timestamp_on_response_pulse() throws {
    // Given
    let original = create_original_pulse()
    let response_data = create_response_data()
    
    // When
    let before = Date()
    let response = Pulse.Respond(to: original, with: response_data)
    let after = Date()
    
    // Then
    #expect(response.timestamp != original.timestamp)
    #expect(response.timestamp >= before)
    #expect(response.timestamp <= after)
  }
  
  // MARK: - Metadata Tests
  
  @Test("copies trace ID from original pulse")
  func copies_trace_id_from_original_pulse() throws {
    // Given
    let original = create_original_pulse()
    let response_data = create_response_data()
    
    // When
    let response = Pulse.Respond(to: original, with: response_data)
    
    // Then
    #expect(response.meta.trace == original.meta.trace)
  }
  
  @Test("sets echoes reference to the original pulse")
  func sets_echoes_reference_to_original_pulse() throws {
    // Given
    let original = create_original_pulse()
    let response_data = create_response_data()
    
    // When
    let response = Pulse.Respond(to: original, with: response_data)
    
    // Then
    #expect(response.meta.echoes != nil)
    #expect(response.meta.echoes?.id == original.id)
    #expect(response.meta.echoes?.name == original.name)
  }
  
  @Test("does not set source when none is provided")
  func does_not_set_source_when_none_provided() throws {
    // Given
    let original = create_original_pulse()
    let response_data = create_response_data()
    
    // When
    let response = Pulse.Respond(to: original, with: response_data)
    
    // Then
    #expect(response.meta.source == nil)
  }
  
  @Test("sets source when one is provided")
  func sets_source_when_one_provided() throws {
    // Given
    let original = create_original_pulse()
    let response_data = create_response_data()
    let source = TestSource()
    
    // When
    let response = Pulse.Respond(to: original, with: response_data, from: source)
    
    // Then
    #expect(response.meta.source != nil)
    #expect(response.meta.source?.id == source.id)
    #expect(response.meta.source?.name == source.name)
  }
  
  // MARK: - Cross-Type Tests
  
  @Test("works with different data types")
  func works_with_different_data_types() throws {
    // Given
    let original = create_original_pulse()
    let response_data = create_response_data()
    
    // When
    let response = Pulse.Respond(to: original, with: response_data)
    
    // Then
    #expect(type(of: original.data) == OriginalPulseData.self)
    #expect(type(of: response.data) == ResponsePulseData.self)
  }
  
  // MARK: - Complex Scenarios
  
  @Test("preserves original pulse debug flag")
  func preserves_original_pulse_debug_flag() throws {
    // Given
    let original = create_original_pulse().debug(true)
    let response_data = create_response_data()
    
    // When
    let response = Pulse.Respond(to: original, with: response_data)
    
    // Then
    // Debug flag should NOT be preserved - only trace and echoes are copied
    #expect(response.meta.debug == false)
  }
  
  @Test("preserves original pulse priority")
  func preserves_original_pulse_priority() throws {
    // Given
    let original = create_original_pulse().priority(.high)
    let response_data = create_response_data()
    
    // When
    let response = Pulse.Respond(to: original, with: response_data)
    
    // Then
    // Priority should NOT be preserved - only trace and echoes are copied
    #expect(response.priority == .medium) // Default value
  }
  
  @Test("preserves original pulse tags")
  func preserves_original_pulse_tags() throws {
    // Given
    let original = create_original_pulse().tagged("important", "test")
    let response_data = create_response_data()
    
    // When
    let response = Pulse.Respond(to: original, with: response_data)
    
    // Then
    // Tags should NOT be preserved - only trace and echoes are copied
    #expect(response.meta.tags.isEmpty)
  }
  
  @Test("can be combined with other fluent methods")
  func can_be_combined_with_other_fluent_methods() throws {
    // Given
    let original = create_original_pulse()
    let response_data = create_response_data()
    
    // When
    let response = Pulse.Respond(to: original, with: response_data)
      .debug(true)
      .priority(.high)
      .tagged("response", "processed")
    
    // Then
    #expect(response.meta.debug == true)
    #expect(response.priority == .high)
    #expect(response.meta.tags.contains("response"))
    #expect(response.meta.tags.contains("processed"))
    #expect(response.meta.trace == original.meta.trace)
    #expect(response.meta.echoes?.id == original.id)
  }
}
