// Copyright © 2025 Cassidy Spring. 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Testing

// MARK: - Test Utilities

/// Helper to track closure execution
struct ClosureTracker {
  private(set) var was_called = false
  
  mutating func track() {
    was_called = true
  }
  
  func verify(called expected: Bool, message: Comment) {
    if expected {
      #expect(was_called, message)
    } else {
      #expect(!was_called, message)
    }
  }
}

/// Test actor for async tests
actor TestActor {
  private var call_count = 0
  
  func compute_string_value(_ input: String) -> String {
    call_count += 1
    return input.uppercased()
  }
  
  func compute_default_string() -> String {
    call_count += 1
    return "DEFAULT"
  }
  
  func get_call_count() -> Int {
    return call_count
  }
}
