// Copyright © 2025 Cassidy Spring. 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Testing

@testable import SableFoundation

@Suite("SableFoundation/Protocols: Uniquable")
struct UniquableTests {
  
  // Test structure that conforms to Uniquable
  struct TestUniquable: Uniquable {
    let id = UUID()
    let value: String
  }
  
  @Test("Uniquable conforms to Identifiable")
  func uniquable_conforms_to_identifiable() throws {
    // Given
    let is_identifiable = (TestUniquable.self as Any) is any Identifiable.Type
    
    // Then
    #expect(is_identifiable)
  }
  
  @Test("Uniquable provides UUID identifier")
  func uniquable_provides_uuid_identifier() throws {
    // Given
    let uniquable = TestUniquable(value: "Test")
    
    // When
    let id = uniquable.id
    
    // Then
    #expect(type(of: id) == type(of: UUID()))
  }
  
  @Test("Different Uniquable instances have different IDs")
  func uniquable_instances_have_different_ids() throws {
    // Given
    let uniquable1 = TestUniquable(value: "Test 1")
    let uniquable2 = TestUniquable(value: "Test 2")
    
    // When
    let id1 = uniquable1.id
    let id2 = uniquable2.id
    
    // Then
    #expect(id1 != id2)
  }
}
