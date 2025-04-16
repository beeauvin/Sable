// Copyright © 2025 Cassidy Spring. 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Testing
import SableFoundation

@testable import SablePulse

@Suite("SablePulse/PulseSource")
struct PulseSourceTests {
  
  // MARK: - Protocol Conformance Tests
  
  @Test("PulseSource conforms to Pulsable")
  func pulse_source_conforms_to_pulsable() throws {
    // Given
    let is_pulsable = (PulseSource.self as Any) is any Pulsable.Type
    
    // Then
    #expect(is_pulsable)
  }
  
  @Test("PulseSource conforms to Representable")
  func pulse_source_conforms_to_representable() throws {
    // Given
    let is_representable = (PulseSource.self as Any) is any Representable.Type
    
    // Then
    #expect(is_representable)
  }
  
  // MARK: - Internal Factory Method Tests
  
  // Test struct that conforms to Representable
  struct TestRepresentable: Representable {
    let id = UUID()
    let name = "Test Representable"
  }
  
  @Test("From(source:) creates PulseSource from Representable")
  func from_source_creates_pulse_source_from_representable() throws {
    // Given
    let representable = TestRepresentable()
    
    // When
    let source = PulseSource.From(source: representable)
    
    // Then
    #expect(source.id == representable.id)
    #expect(source.name == representable.name)
  }
  
  /*
   * Test for From(pulse:) is omitted until Pulse is available in the repository.
   * Add the following test once Pulse is available:
   *
   * @Test("From(pulse:) creates PulseSource from Pulse")
   * func from_pulse_creates_pulse_source_from_pulse() throws {
   *   // Given
   *   let data = TestPulseData(value: "Test Data")
   *   let pulse = Pulse(data: data)
   *
   *   // When
   *   let source = PulseSource.From(pulse: pulse)
   *
   *   // Then
   *   #expect(source.id == pulse.id)
   *   #expect(source.name == pulse.name)
   * }
   */
  
  // MARK: - Behavior Tests
  
  @Test("PulseSource description combines name and id")
  func pulse_source_description_combines_name_and_id() throws {
    // Given
    let representable = TestRepresentable()
    let source = PulseSource.From(source: representable)
    
    // When
    let description = source.description
    
    // Then
    #expect(description == "\(source.name):\(source.id)")
  }
  
  @Test("Different PulseSource instances have different ids")
  func different_pulse_source_instances_have_different_ids() throws {
    // Given
    let representable1 = TestRepresentable()
    let representable2 = TestRepresentable()
    
    // When
    let source1 = PulseSource.From(source: representable1)
    let source2 = PulseSource.From(source: representable2)
    
    // Then
    #expect(source1.id != source2.id)
  }
}
