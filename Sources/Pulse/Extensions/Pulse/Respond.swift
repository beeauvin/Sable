// Copyright © 2025 Cassidy Spring (Bee). 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Obsidian

/// Extension providing a static factory method for creating response pulses.
///
/// This extension adds a dedicated method for creating pulses that respond to
/// other pulses, maintaining causal chains and trace information while providing
/// a natural language interface.
extension Pulse {
  /// Creates a new pulse that responds to another pulse.
  ///
  /// This factory method creates a response pulse that:
  /// - Maintains the same trace ID as the original pulse
  /// - Sets the original pulse as the one being echoed
  /// - Optionally sets a new source component
  /// - Creates a new pulse ID and timestamp
  ///
  /// ```swift
  /// // Create a simple response
  /// let response = Pulse.Respond(to: original_pulse, with: completion_data)
  ///
  /// // Create a response with a specific source
  /// let response = Pulse.Respond(to: original_pulse, with: result_data, from: processing_service)
  /// ```
  ///
  /// Use this method when handling a pulse and generating a direct response
  /// to preserve the causal relationship and contextual information needed
  /// for tracing and debugging.
  ///
  /// - Parameters:
  ///   - original: The pulse being responded to
  ///   - data: The data payload for the response pulse
  ///   - source: Optional source for the response (if nil, no source is set)
  /// - Returns: A new pulse that echoes the original pulse
  public static func Respond<Original: Pulsable>(
    to original: Pulse<Original>,
    with data: Data,
    from source: Optional<any Representable> = .none
  ) -> Pulse<Data> {
    // Create a new pulse with the provided data
    let pulse = Pulse(data).echoes(original)
    
    // If a source was provided, set it in the metadata
    if let source = source {
      return pulse.from(source)
    }
    
    // Return a new pulse with the updated metadata
    return pulse
  }
}
