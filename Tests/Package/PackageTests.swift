// Copyright © 2025 Cassidy Spring. 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Testing

@testable import Sable

@Suite("Sable/Package")
struct SableTests {
  /// Test presumably only compiles if it's true.
  @Test("Sable exists")
  func sable_exists() throws {
    let sable: Optional<Sable.Type> = Sable.self
    #expect(sable != .none)
  }

  /// Test presumably only compiles if it's true.
  @Test("Sable re-exports SablePulse (simple test)")
  func sable_re_exports_sable_pulse() throws {
    let sable_pulse: Optional<SablePulse.Type> = SablePulse.self
    #expect(sable_pulse != .none)
  }
}
