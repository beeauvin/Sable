// Copyright © 2025 Cassidy Spring. 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Obsidian

/// Extension providing a fluent builder API for Pulse instances.
///
/// These methods enable modification of Pulse properties through a natural language
/// interface while maintaining immutability. Each method returns a new Pulse instance
/// with the desired modifications, preserving the original's identity information.
///
/// Use these methods to create rich, contextual pulses through method chaining:
///
/// ```swift
/// let enhanced_pulse = Pulse(login_event)
///   .debug()
///   .priority(.high)
///   .tagged("auth", "security")
///   .from(auth_service)
/// ```
///
/// The fluent API follows Sable's core design principles of natural language interfaces,
/// strong type safety, and immutability for thread safety.
extension Pulse {
  /// Marks this pulse as a debug pulse for logging and tracing
  ///
  /// Debug pulses may receive special handling:
  /// - Additional logging and tracing
  /// - Inclusion in debug visualizations
  /// - Heightened verbosity in error contexts
  ///
  /// ```swift
  /// let pulse = Pulse(event).debug() // Defaults to true
  /// let regular_pulse = debug_pulse.debug(false) // Disable debugging
  /// ```
  public func debug(_ enabled: Bool = true) -> Pulse<Data> {
    return fluently(meta: meta.fluently(debug: enabled))
  }
  
  /// Establishes a causal relationship with another pulse
  ///
  /// This both copies the trace ID from the original pulse and sets
  /// the `echoes` reference, maintaining the complete causal chain.
  ///
  /// Use this when a pulse is emitted as a direct result of processing
  /// another pulse, establishing a clear cause-and-effect relationship.
  ///
  /// ```swift
  /// // Create a response that maintains the trace
  /// let response = Pulse(completion_event).echoes(original_pulse)
  /// ```
  public func echoes<T: Pulsable>(_ pulse: Pulse<T>) -> Pulse<Data> {
    return fluently(meta: meta.fluently(
      trace: pulse.meta.trace,
      echoes: PulseSource.From(source: pulse)
    ))
  }
  
  /// Sets the source of this pulse
  ///
  /// The source identifies the component or system that created this pulse.
  /// This provides context for debugging and tracing message flows.
  ///
  /// ```swift
  /// let pulse = Pulse(event).from(auth_service)
  /// ```
  ///
  /// Typically set automatically by the `PulseEmitter`, but can be
  /// manually specified when needed.
  public func from(_ representable: any Representable) -> Pulse<Data> {
    return fluently(meta: meta.fluently(source: PulseSource.From(source: representable)))
  }
  
  /// Sets the processing priority of this pulse
  ///
  /// Higher-priority pulses are processed before lower-priority ones
  /// when resources are constrained.
  ///
  /// ```swift
  /// let critical_pulse = Pulse(event).priority(.high)
  /// let background_pulse = Pulse(stats_event).priority(.low)
  /// ```
  public func priority(_ priority: TaskPriority) -> Pulse<Data> {
    return fluently(meta: meta.fluently(priority: priority))
  }
  
  /// Adds tags to this pulse for filtering and routing
  ///
  /// Tags provide a lightweight extension mechanism for pulse metadata.
  /// Multiple tags can be added to create rich categorization.
  ///
  /// By default, this method adds the specified tags to any existing tags.
  /// Set `reset` to true to replace all existing tags with the new ones.
  ///
  /// ```swift
  /// // Add tags to existing ones
  /// let pulse = Pulse(event).tagged("auth", "security-audit")
  ///
  /// // Replace all existing tags
  /// let pulse = Pulse(event).tagged("new-tag", reset: true)
  /// ```
  public func tagged(_ tags: String..., reset: Bool = false) -> Pulse<Data> {
    var updated_tags = reset ? [] : meta.tags
    tags.forEach { updated_tags.insert($0) }
    
    return fluently(meta: meta.fluently(tags: updated_tags))
  }
  
  // To be added to SablePulse/Source/Extensions/Pulse/FluentBuilder.swift
  // after the existing extension methods
  
  /// Adopts all metadata from another pulse
  ///
  /// This method copies the complete metadata from the provided pulse while
  /// preserving the current pulse's identity and data. Use it when you want
  /// to create a pulse with identical operational characteristics to another.
  ///
  /// ```swift
  /// // Create a new pulse with the same metadata as an existing one
  /// let template_pulse = retrieve_template_pulse()
  /// let new_pulse = Pulse(event_data).like(template_pulse)
  /// ```
  ///
  /// All metadata properties are copied, including:
  /// - Debug status
  /// - Trace ID
  /// - Source information
  /// - Echoed pulse references
  /// - Priority level
  /// - Tags
  ///
  /// The original pulse's identity (ID and timestamp) and data are preserved.
  public func like<T: Pulsable>(_ pulse: Pulse<T>) -> Pulse<Data> {
    return fluently(meta: pulse.meta)
  }
}
