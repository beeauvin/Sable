// Copyright © 2025 Cassidy Spring. 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import SableFoundation

/// Internal extension providing fluent builder pattern support for Pulse instances.
///
/// This extension enables convenient modification of Pulse instances through a fluent interface,
/// making it easier to create derived Pulses while preserving core identity information.
/// The methods maintain immutability by creating new instances rather than modifying existing ones.
internal extension Pulse {
  /// Creates a new Pulse instance with selectively updated properties.
  ///
  /// This static factory method enables the fluent builder pattern by constructing
  /// a new Pulse that preserves the identity (id and timestamp) of the original
  /// while optionally updating the data payload and/or metadata.
  ///
  /// ```swift
  /// // Create a new pulse with updated metadata but same data
  /// let updated_pulse = Pulse.Fluently(original_pulse, meta: new_meta)
  ///
  /// // Create a new pulse with updated data but same metadata
  /// let transformed_pulse = Pulse.Fluently(original_pulse, data: new_data)
  ///
  /// // Create a new pulse with both updated data and metadata
  /// let complete_update = Pulse.Fluently(original_pulse, data: new_data, meta: new_meta)
  /// ```
  ///
  /// - Parameters:
  ///   - pulse: The original Pulse instance whose identity will be preserved
  ///   - data: Optional new data payload (defaults to nil, which retains original data)
  ///   - meta: Optional new metadata (defaults to nil, which retains original metadata)
  /// - Returns: A new Pulse instance with the same identity but potentially updated components
  static func Fluently(
    _ pulse: Pulse<Data>,
    data: Optional<Data> = .none,
    meta: Optional<PulseMeta> = .none
  ) -> Pulse<Data> {
    return Pulse(
      id: pulse.id,
      timestamp: pulse.timestamp,
      data: data.otherwise(pulse.data),
      meta: meta.otherwise(pulse.meta)
    )
  }
  
  /// Creates a new Pulse with selectively updated properties using the fluent pattern.
  ///
  /// This instance method provides a more natural interface for the fluent builder pattern,
  /// allowing callsite code to create modified versions of a Pulse through method chaining.
  /// It preserves the identity of the original Pulse while allowing updates to data and metadata.
  ///
  /// ```swift
  /// // Create a simple update with new metadata
  /// let debug_pulse = original_pulse.fluently(meta: debug_meta)
  ///
  /// // Chain multiple fluent operations
  /// let final_pulse = original_pulse
  ///   .debug(true)                // Uses fluently internally
  ///   .priority(.high)            // Uses fluently internally
  ///   .tagged("auth", "critical") // Uses fluently internally
  /// ```
  ///
  /// - Parameters:
  ///   - data: Optional new data payload (defaults to nil, which retains original data)
  ///   - meta: Optional new metadata (defaults to nil, which retains original metadata)
  /// - Returns: A new Pulse instance with the same identity but potentially updated components
  func fluently(
    data: Optional<Data> = .none,
    meta: Optional<PulseMeta> = .none
  ) -> Pulse<Data> {
    return Pulse.Fluently(self, data: data, meta: meta)
  }
}
