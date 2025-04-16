// Copyright © 2025 Cassidy Spring. 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Testing

@testable import SableFoundation

@Suite("SableFoundation/Protocols: Namable")
struct NamableTests {
  
  // Basic test structure using default implementation
  struct DefaultNamable: Namable {}
  
  // Test structure with custom name implementation
  struct CustomNamable: Namable {
    let name: String
  }
  
  // Generic test structure to verify generic type name handling
  struct GenericNamable<T>: Namable {
    let value: T
  }
  
  @Test("Default implementation returns type name")
  func default_implementation_returns_type_name() throws {
    // Given
    let namable = DefaultNamable()
    
    // When
    let name = namable.name
    
    // Then
    #expect(name == "DefaultNamable")
  }
  
  @Test("Custom implementation returns provided name")
  func custom_implementation_returns_provided_name() throws {
    // Given
    let custom_name = "Custom Name"
    let namable = CustomNamable(name: custom_name)
    
    // When
    let name = namable.name
    
    // Then
    #expect(name == custom_name)
  }
  
  @Test("Generic type names include type parameters")
  func generic_type_names_include_parameters() throws {
    // Given
    let namable = GenericNamable(value: "String Value")
    
    // When
    let name = namable.name
    
    // Then
    #expect(name == "GenericNamable<String>")
  }
  
  @Test("Default implementation does not include parentheses")
  func default_implementation_excludes_parentheses() throws {
    // Given
    let namable = DefaultNamable()
    
    // When
    let name = namable.name
    let description = String(describing: namable)
    
    // Then
    #expect(!name.contains("("))
    #expect(!name.contains(")"))
    #expect(description.contains("("))
    #expect(description.contains(")"))
  }
}
