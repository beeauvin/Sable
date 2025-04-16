// Copyright © 2025 Cassidy Spring. 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import SableFoundation

/// A lightweight, type-safe message container for async communication.
///
/// `Pulse` is the core message unit in the SablePulse system, encapsulating
/// typed data along with metadata that provides operational context. Pulses
/// can form causal chains to track related messages and maintain tracing
/// information across the system.
///
/// Pulses are immutable, with all modifications creating new instances through
/// the fluent builder pattern. This ensures thread safety when passing messages
/// across actor boundaries.
///
/// Example usage:
///
/// ```swift
/// // Create a simple pulse with default metadata
/// let login_event = UserLoggedIn(user_id: user.id)
/// let pulse = Pulse(login_event)
///
/// // Create a pulse with custom metadata
/// let enhanced_pulse = pulse
///   .priority(.high)
///   .tagged("auth", "security")
///   .from(auth_service)
///
/// // Create a response pulse that maintains causal chain
/// let response_pulse = Pulse(AuthenticationCompleted(success: true))
///   .echoes(enhanced_pulse)
/// ```
///
/// `Pulse` conforms to both `Pulsable` and `Representable`, ensuring it can safely
/// traverse actor boundaries and providing identity information for logging and debugging.
public struct Pulse<Data: Pulsable>: Pulsable, Representable {
  /// Unique identifier for tracking the pulse through the system
  public let id: UUID
  
  /// Timestamp indicating when the pulse was created
  public let timestamp: Date
  
  /// The strongly-typed data encapsulated by this pulse
  public let data: Data
  
  /// Metadata providing system-level operational context
  public let meta: PulseMeta
  
  /// A human-readable name for the pulse
  public var name: String {
    // Use type name for better readability in logs and debugging
    return "Pulse:\(String(describing: type(of: data)))"
  }
  
  /// Access to the priority as a strongly-typed value
  public var priority: TaskPriority {
    return TaskPriority(rawValue: meta.priority)
  }
  
  /// Creates a new pulse with the provided data and default metadata
  public init(_ data: Data) {
    self.id = UUID()
    self.timestamp = Date()
    self.data = data
    self.meta = PulseMeta()
  }
  
  /// Private initializer used by the fluent builder pattern
  private init(id: UUID, timestamp: Date, data: Data, meta: PulseMeta) {
    self.id = id
    self.timestamp = timestamp
    self.data = data
    self.meta = meta
  }
  
  /// Helper method for fluent builders to create new instances
  internal static func Fluently(_ pulse: Pulse<Data>, meta: PulseMeta) -> Pulse<Data> {
    return Pulse(
      id: pulse.id,
      timestamp: pulse.timestamp,
      data: pulse.data,
      meta: meta
    )
  }
}
