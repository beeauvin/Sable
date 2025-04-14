// Copyright © 2025 Cassidy Spring. 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Testing

@testable import SableFoundation

@Suite("SableFoundation")
struct SableFoundationTests {

  @Test("Module Version")
  func test_module_version() throws {
    #expect(SableFoundation.version == "0.1.0")
  }

  /// Test presumably only compiles if it's true.
  @Test("Re-exports Foundation (simple test)")
  func re_exports_foundation() throws {
    let uuid = UUID()
    #expect(uuid == uuid)
  }
}
