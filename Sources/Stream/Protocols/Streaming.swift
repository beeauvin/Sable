// Copyright © 2025 Cassidy Spring (Bee). 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Obsidian

/// A protocol that defines the core operations for stream-like components.
///
/// `Streaming` provides the interface for bidirectional communication pathways with
/// explicit lifecycle management. Unlike the simpler `Channeling` protocol, streaming
/// components support release operations and provide detailed result information about
/// their state transitions.
///
/// Streams are designed for scenarios where:
/// - Components need to be notified when connections are closed
/// - Explicit lifecycle control is required
/// - Error handling for connection state is important
/// - Bidirectional awareness between endpoints is valuable
///
/// The protocol combines identity capabilities from `Representable` with messaging
/// operations that return detailed results about success or failure states.
///
/// ```swift
/// struct StreamWrapper<Data: Pulsable>: Streaming {
///   private let inner_stream: Stream<Data>
///
///   var id: UUID { inner_stream.id }
///   var name: String { "Wrapper:\(inner_stream.name)" }
///
///   init(handler: @escaping ChannelHandler<Data>) {
///     self.inner_stream = Stream(handler: handler)
///   }
///
///   func send(_ pulse: Pulse<Data>) async -> StreamResult {
///     return await inner_stream.send(pulse)
///   }
///
///   func release() async -> StreamResult {
///     return await inner_stream.release()
///   }
/// }
/// ```
///
/// This protocol enables building sophisticated stream-based architectures with
/// predictable lifecycle management while maintaining compatibility through
/// composition and delegation patterns.
public protocol Streaming<Data>: Representable where Data: Pulsable {
  /// The type of data this stream can handle
  associatedtype Data: Pulsable
  
  /// Sends a pulse to this stream for processing.
  ///
  /// - Parameter pulse: The typed pulse to send through this stream
  /// - Returns: A result indicating success or a specific stream error
  func send(_ pulse: Pulse<Data>) async -> StreamResult
  
  /// Releases this stream, preventing further pulse processing.
  ///
  /// - Returns: A result indicating success or a specific stream error
  func release() async -> StreamResult
}
