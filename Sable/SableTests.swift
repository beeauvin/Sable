// Copyright © 2025 Cassidy Spring. 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Testing

@testable import Sable

@Suite("Sable")
struct SableTests {

  @Test("Module Version")
  func test_module_version() throws {
    #expect(Sable.version == "0.0.1")
  }
}
