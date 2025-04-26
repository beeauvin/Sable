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
  
  @Test("Pulse creates a Pulse containing StreamReleased")
  func pulse_creates_pulse_containing_stream_released() throws {
    // Given
    let id: UUID = UUID()

    // When
    let pulse = Pulse(StreamReleased(stream_id: id))
    
    // Then
    #expect(type(of: pulse.data) == StreamReleased.self)
    #expect(pulse.data.stream_id == id)
  }
}
