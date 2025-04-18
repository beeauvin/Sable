// Copyright © 2025 Cassidy Spring. 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import SableFoundation

/// Metadata that provides operational context for a pulse message.
///
/// `PulseMeta` encapsulates system-level metadata about a pulse, including:
/// - Debug status for development and testing
/// - Tracing for message flow visualization
/// - Source tracking for message origin
/// - Echo tracking for causal relationships
/// - Priority for task scheduling
/// - Tags for filtering and categorization
///
/// This structure is primarily managed by the internal fluent builders on `Pulse`
/// and is not typically created directly by end users.
///
/// The metadata travels with each pulse through the system, enabling:
/// - Operational tracing for debugging complex message flows
/// - Priority-based scheduling in async contexts
/// - Causal chain tracking to understand message relationships
/// - Filtering and routing based on tags
///
/// `PulseMeta` conforms to `Pulsable` to ensure it can safely traverse actor
/// boundaries while maintaining type safety.
@frozen public struct PulseMeta: Pulsable {
  /// Indicates whether this pulse was created in debug mode.
  ///
  /// When true, the pulse may receive special handling:
  /// - Additional logging and tracing
  /// - Inclusion in debug visualizations
  /// - Heightened verbosity in error contexts
  ///
  /// Debug pulses are particularly useful during development to track
  /// specific message flows through complex systems.
  public let debug: Bool
  
  /// A unique identifier for tracing this pulse through the system.
  ///
  /// The trace ID remains consistent across pulse transformations and can be used
  /// to visualize a complete message flow. Multiple pulses may share the same
  /// trace ID if they are part of the same logical operation or user interaction.
  ///
  /// This enables building comprehensive visualizations of message propagation
  /// throughout a distributed system.
  public let trace: UUID
  
  /// The system or component that generated this pulse.
  ///
  /// Captures the origin of a pulse, providing context about where the message
  /// was created. This is essential for debugging and for understanding
  /// message flow directionality.
  ///
  /// The source is typically generated automatically from the emitting actor
  /// or component's identity information.
  public let source: Optional<PulseSource>
  
  /// The pulse that caused or preceded this one.
  ///
  /// Establishes causal relationships between pulses, enabling the construction
  /// of causal chains to understand how one message led to another.
  ///
  /// When a component processes a pulse and emits a new one in response,
  /// the original pulse's identity is captured here to maintain the
  /// relationship between cause and effect.
  public let echoes: Optional<PulseSource>
  
  /// The scheduling priority of this pulse.
  ///
  /// Determines how urgently this pulse should be processed within
  /// task scheduling systems. Higher priority pulses are processed
  /// before lower priority ones when resources are constrained.
  ///
  /// Stored as a raw value to enable serialization, but accessors on
  /// `Pulse` provide strongly-typed access via `TaskPriority`.
  public let priority: TaskPriority.RawValue
  
  /// A set of string tags that provide a simple extension mechanism.
  ///
  /// Tags enable users to extend pulse functionality without modifying the
  /// core structure. They serve multiple purposes:
  /// - Feature flagging to enable or disable specific behaviors
  /// - Custom routing based on application-specific concerns
  /// - Contextual metadata that specific receivers might understand
  /// - Application-level categorization beyond the core framework
  ///
  /// Since PulseMeta itself isn't directly extendable (at least until potential
  /// future language features like union types), tags provide a lightweight way
  /// for users to add their own metadata and build custom behaviors on top of
  /// the messaging system.
  public let tags: Set<String>
  
  /// Creates a new instance of pulse metadata with specified attributes.
  ///
  /// This initializer is internal as end users should not create `PulseMeta`
  /// directly. Instead, they should use the fluent builders on `Pulse`.
  ///
  /// - Parameters:
  ///   - debug: Whether this pulse is in debug mode
  ///   - trace: A unique identifier for tracing this pulse
  ///   - source: The component that generated this pulse
  ///   - echoes: The pulse that caused or preceded this one
  ///   - priority: The processing priority for this pulse
  ///   - tags: A set of string tags for filtering and categorization
  internal init(
    debug: Bool = false,
    trace: UUID = UUID(),
    source: Optional<PulseSource> = .none,
    echoes: Optional<PulseSource> = .none,
    priority: TaskPriority = .medium,
    tags: Set<String> = []
  ) {
    self.debug = debug
    self.trace = trace
    self.source = source
    self.echoes = echoes
    self.priority = priority.rawValue
    self.tags = tags
  }
}
