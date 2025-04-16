// Copyright © 2025 Cassidy Spring. 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Testing

@testable import SableFoundation

@Suite("SableFoundation/Protocols: Representable")
struct RepresentableTests {
  
  // Basic test structure with minimal implementation
  struct DefaultRepresentable: Representable {
    let id = UUID()
    // Uses default implementations for name and description
  }
  
  // Test structure with custom name
  struct CustomNameRepresentable: Representable {
    let id = UUID()
    let name: String
    // Uses default implementation for description
  }
  
  // Test structure with custom description
  struct CustomDescriptionRepresentable: Representable {
    let id = UUID()
    let description: String
    // Uses default implementation for name
  }
  
  @Test("Representable conforms to Uniquable")
  func representable_conforms_to_uniquable() throws {
    // Given
    let is_uniquable = (DefaultRepresentable.self as Any) is any Uniquable.Type
    
    // Then
    #expect(is_uniquable)
  }
  
  @Test("Representable conforms to Namable")
  func representable_conforms_to_namable() throws {
    // Given
    let is_namable = (DefaultRepresentable.self as Any) is any Namable.Type
    
    // Then
    #expect(is_namable)
  }
  
  @Test("Representable conforms to Describable")
  func representable_conforms_to_describable() throws {
    // Given
    let is_describable = (DefaultRepresentable.self as Any) is any Describable.Type
    
    // Then
    #expect(is_describable)
  }
  
  @Test("Default description combines name and id")
  func default_description_combines_name_and_id() throws {
    // Given
    let representable = DefaultRepresentable()
    
    // When
    let description = representable.description
    
    // Then
    #expect(description == "\(representable.name):\(representable.id)")
  }
  
  @Test("Default description works with custom name")
  func default_description_works_with_custom_name() throws {
    // Given
    let custom_name = "Custom Name"
    let representable = CustomNameRepresentable(name: custom_name)
    
    // When
    let description = representable.description
    
    // Then
    #expect(description == "\(custom_name):\(representable.id)")
  }
  
  @Test("Custom description overrides default implementation")
  func custom_description_overrides_default() throws {
    // Given
    let custom_description = "Custom Description"
    let representable = CustomDescriptionRepresentable(description: custom_description)
    
    // When
    let description = representable.description
    
    // Then
    #expect(description == custom_description)
    #expect(description != "\(representable.name):\(representable.id)")
  }
}
