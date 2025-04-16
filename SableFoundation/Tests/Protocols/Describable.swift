// Copyright © 2025 Cassidy Spring. 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Testing

@testable import SableFoundation

@Suite("SableFoundation/Protocols: Describable")
struct DescribableTests {
  
  // Test structure that conforms to Describable
  struct TestDescribable: Describable {
    let description: String
  }
  
  @Test("Describable provides description")
  func describable_provides_description() throws {
    // Given
    let test_value = "Test"
    let describable = TestDescribable(description: test_value)
    
    // When
    let description = describable.description
    
    // Then
    #expect(description == test_value)
  }
}
