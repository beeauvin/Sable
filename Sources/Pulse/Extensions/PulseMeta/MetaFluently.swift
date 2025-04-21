// Copyright © 2025 Cassidy Spring (Bee). 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Obsidian

/// Extension to `PulseMeta` providing fluent modification capabilities.
///
/// These methods enable immutable transformation of `PulseMeta` instances
/// through a natural language fluent interface. The design maintains
/// immutability while allowing for property updates, which aligns with
/// Sable's design principle of thread safety in actor-based environments.
///
/// Fluent builders are primarily used internally by the `Pulse` type to
/// implement its own public fluent interface, though they may be used
/// directly when creating custom metadata handling.
///
/// ```swift
/// // Example of internal usage through Pulse's fluent interface
/// let enhanced_pulse = original_pulse
///   .debug(true)
///   .priority(.high)
///   .tagged("critical", "auth")
/// ```
internal extension PulseMeta {
  /// Creates a new PulseMeta instance with updated properties.
  ///
  /// Used internally by the fluent builders on `Pulse` to maintain immutability
  /// while allowing property updates.
  ///
  /// - Parameters:
  ///   - original: The source PulseMeta instance to copy values from
  ///   - debug: Whether this pulse is in debug mode
  ///   - trace: A unique identifier for tracing this pulse
  ///   - source: The component that generated this pulse
  ///   - echoes: The pulse that caused or preceded this one
  ///   - priority: The processing priority for this pulse
  ///   - tags: A set of string tags for filtering and categorization
  /// - Returns: A new PulseMeta instance with the specified properties updated
  static func Fluently(
    _ original: PulseMeta,
    debug: Optional<Bool> = .none,
    trace: Optional<UUID> = .none,
    source: Optional<PulseSource> = .none,
    echoes: Optional<PulseSource> = .none,
    priority: Optional<TaskPriority> = .none,
    tags: Optional<Set<String>> = .none
  ) -> PulseMeta {
    return PulseMeta(
      debug: debug.otherwise(original.debug),
      trace: trace.otherwise(original.trace),
      source: source.optionally(original.source),
      echoes: echoes.optionally(original.echoes),
      priority: priority.otherwise(TaskPriority(rawValue: original.priority)),
      tags: tags.otherwise(original.tags)
    )
  }
  
  /// Creates a new PulseMeta instance with updated properties.
  ///
  /// This instance method provides a more ergonomic way to use the fluent pattern,
  /// automatically passing the current instance to the static Fluently method.
  ///
  /// - Parameters:
  ///   - debug: Whether this pulse is in debug mode
  ///   - trace: A unique identifier for tracing this pulse
  ///   - source: The component that generated this pulse
  ///   - echoes: The pulse that caused or preceded this one
  ///   - priority: The processing priority for this pulse
  ///   - tags: A set of string tags for filtering and categorization
  /// - Returns: A new PulseMeta instance with the specified properties updated
  func fluently(
    debug: Optional<Bool> = .none,
    trace: Optional<UUID> = .none,
    source: Optional<PulseSource> = .none,
    echoes: Optional<PulseSource> = .none,
    priority: Optional<TaskPriority> = .none,
    tags: Optional<Set<String>> = .none
  ) -> PulseMeta {
    return PulseMeta.Fluently(
      self,
      debug: debug,
      trace: trace,
      source: source,
      echoes: echoes,
      priority: priority,
      tags: tags
    )
  }
}
