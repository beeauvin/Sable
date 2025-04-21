// Copyright © 2025 Cassidy Spring (Bee). 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Obsidian

/// An internal structure that represents the origin of a pulse message.
///
/// `PulseSource` is used within the Sable system to track message provenance
/// and causation chains. It appears in `PulseMeta` through the `source` and `echoes`
/// properties, providing information about where pulses originated and what preceded them.
///
/// This type is not meant to be created directly by end users, but rather is managed
/// internally by the Sable system. The `Pulsable` and `Representable` conformances
/// ensure it can safely traverse actor boundaries and provide consistent identity information.
@frozen public struct PulseSource: Pulsable, Representable {
  /// A unique identifier for the pulse source.
  public let id: UUID
  
  /// A human-readable name for the pulse source.
  public let name: String
  
  /// Creates a `PulseSource` from any type that conforms to `Representable`.
  ///
  /// Used internally by the Sable system to track the origins of pulse messages.
  ///
  /// - Parameter source: A `Representable` object to create a source from
  /// - Returns: A new `PulseSource` with the same identity and name as the source
  internal static func From(source: any Representable) -> PulseSource {
    return PulseSource(id: source.id, name: source.name)
  }
  
  /// Creates a `PulseSource` from a pulse message.
  ///
  /// Used internally by the Sable system to track causation chains,
  /// where one pulse causes another to be emitted.
  ///
  /// - Parameter pulse: A `Pulse` message to create a source from
  /// - Returns: A new `PulseSource` with the same identity and name as the pulse
  // internal static func From<Data: Pulsable>(pulse: Pulse<Data>) -> PulseSource {
  //   return PulseSource(id: pulse.id, name: pulse.name)
  // }
  
  /// Private initializer to ensure `PulseSource` instances are only created
  /// through the internal factory methods.
  ///
  /// - Parameters:
  ///   - id: A unique identifier for the source
  ///   - name: A human-readable name for the source
  private init(id: UUID, name: String) {
    self.id = id
    self.name = name
  }
}
