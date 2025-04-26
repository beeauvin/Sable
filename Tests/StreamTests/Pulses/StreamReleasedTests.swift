// Copyright © 2025 Cassidy Spring (Bee). 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Testing
import Obsidian

@testable import Sable

@Suite("Sable/Stream/Types: StreamReleased")
struct StreamReleasedTests {
  
  // MARK: - Protocol Conformance Tests
  
  @Test("conforms to Pulsable")
  func conforms_to_pulsable() throws {
    let is_pulsable = (StreamReleased.self as Any) is any Pulsable.Type
    #expect(is_pulsable)
  }
  
  // MARK: - Factory Method Tests
  
  @Test("pulse() creates a Pulse containing StreamReleased")
  func pulse_creates_pulse_containing_stream_released() throws {
    // When
    let pulse = StreamReleased.pulse()
    
    // Then
    #expect(type(of: pulse.data) == StreamReleased.self)
  }
  
  @Test("pulse() creates a unique pulse each time")
  func pulse_creates_unique_pulse_each_time() throws {
    // When
    let pulse1 = StreamReleased.pulse()
    let pulse2 = StreamReleased.pulse()
    
    // Then
    #expect(pulse1.id != pulse2.id)
  }
}
