// Copyright © 2025 Cassidy Spring (Bee). 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Testing
import Obsidian

@testable import Sable

@Suite("Sable/Pulse/Metadata: PulseSource")
struct PulseSourceTests {
  
  // MARK: - Test Data
  
  struct TestRepresentable: Representable {
    let id = UUID()
    let name = "Test Representable"
  }
  
  // MARK: - Protocol Conformance Tests
  
  @Test("conforms to Pulsable")
  func conforms_to_pulsable() throws {
    let is_pulsable = (PulseSource.self as Any) is any Pulsable.Type
    #expect(is_pulsable)
  }
  
  @Test("conforms to Representable")
  func conforms_to_representable() throws {
    let is_representable = (PulseSource.self as Any) is any Representable.Type
    #expect(is_representable)
  }
  
  // MARK: - Factory Method Tests
  
  @Test("From(source:) preserves original id")
  func from_source_preserves_original_id() throws {
    // Given
    let representable = TestRepresentable()
    
    // When
    let source = PulseSource.From(source: representable)
    
    // Then
    #expect(source.id == representable.id)
  }
  
  @Test("From(source:) preserves original name")
  func from_source_preserves_original_name() throws {
    // Given
    let representable = TestRepresentable()
    
    // When
    let source = PulseSource.From(source: representable)
    
    // Then
    #expect(source.name == representable.name)
  }
  
  // MARK: - Identity Tests
  
  @Test("different instances have unique ids")
  func different_instances_have_unique_ids() throws {
    // Given
    let representable1 = TestRepresentable()
    let representable2 = TestRepresentable()
    
    // When
    let source1 = PulseSource.From(source: representable1)
    let source2 = PulseSource.From(source: representable2)
    
    // Then
    #expect(source1.id != source2.id)
  }
  
  @Test("instances created from same Representable have same ids")
  func instances_from_same_representable_have_same_ids() throws {
    // Given
    let representable = TestRepresentable()
    
    // When
    let source1 = PulseSource.From(source: representable)
    let source2 = PulseSource.From(source: representable)
    
    // Then
    #expect(source1.id == source2.id)
  }
  
  // MARK: - Description Tests
  
  @Test("description combines name and id")
  func description_combines_name_and_id() throws {
    // Given
    let representable = TestRepresentable()
    let source = PulseSource.From(source: representable)
    
    // When
    let description = source.description
    
    // Then
    #expect(description == "\(source.name):\(source.id)")
  }
  
  @Test("description uses inherited format from Representable")
  func description_uses_inherited_format() throws {
    // Given
    let representable = TestRepresentable()
    let source = PulseSource.From(source: representable)
    
    // When
    let source_description = source.description
    let representable_format = "\(source.name):\(source.id)"
    
    // Then
    #expect(source_description == representable_format)
  }
  
  // MARK: - Equality Tests
  
  @Test("instances with same properties are equal")
  func instances_with_same_properties_are_equal() throws {
    // Given
    let representable = TestRepresentable()
    
    // When
    let source1 = PulseSource.From(source: representable)
    let source2 = PulseSource.From(source: representable)
    
    // Then
    #expect(source1 == source2)
  }
  
  @Test("instances with different properties are not equal")
  func instances_with_different_properties_are_not_equal() throws {
    // Given
    let representable1 = TestRepresentable()
    
    // Create a custom representable with different properties
    struct CustomRepresentable: Representable {
      let id = UUID()
      let name = "Different Representable"
    }
    let representable2 = CustomRepresentable()
    
    // When
    let source1 = PulseSource.From(source: representable1)
    let source2 = PulseSource.From(source: representable2)
    
    // Then
    #expect(source1 != source2)
  }
}
