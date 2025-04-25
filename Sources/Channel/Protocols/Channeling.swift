// Copyright © 2025 Cassidy Spring (Bee). 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Obsidian

/// A protocol that defines the core operations for channel-like components.
///
/// `Channeling` standardizes the interface for any component that provides
/// channel-like functionality, whether directly implementing a channel or
/// wrapping one. This allows for consistent usage patterns and enables
/// composition and delegation without tight coupling to the concrete `Channel` type.
///
/// Implementers of this protocol must provide the ability to:
/// - Send a strongly-typed pulse to a handler
/// - Release the channel, preventing further message processing
///
/// Both operations return a `ChannelResult` to enable proper error handling.
///
/// ```swift
/// struct ChannelWrapper<Data: Pulsable>: Channeling {
///   private let inner_channel: Channel<Data>
///
///   init(handler: @escaping ChannelHandler<Data>) {
///     self.inner_channel = Channel(handler: handler)
///   }
///
///   func send(_ pulse: Pulse<Data>) async -> ChannelResult {
///     return await inner_channel.send(pulse)
///   }
///
///   func release() async -> ChannelResult {
///     return await inner_channel.release()
///   }
/// }
/// ```
///
/// This protocol enables building more complex channel-based architectures
/// through composition and wrapping, while maintaining a consistent interface.
public protocol Channeling<Data> {
  /// The type of data this channel can handle
  associatedtype Data: Pulsable
  
  /// Sends a pulse to this channel for processing.
  ///
  /// - Parameter pulse: The typed pulse to send through this channel
  /// - Returns: A result indicating success or a specific channel error
  func send(_ pulse: Pulse<Data>) async -> ChannelResult
  
  /// Releases this channel, preventing further pulse processing.
  ///
  /// - Returns: A result indicating success or a specific channel error
  func release() async -> ChannelResult
}
