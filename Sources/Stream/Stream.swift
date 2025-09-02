// Copyright © 2025 Cassidy Spring (Bee). 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Obsidian

/// A communication pathway with built-in bidirectional lifecycle awareness. Built on
/// `Pipe` primitives for high-performance message delivery.
///
/// `Stream` extends Sable's messaging architecture by providing a connection between
/// components with mutual awareness of lifecycle events. Unlike a regular `Channel`,
/// which offers simple fire-and-forget messaging, a `Stream` establishes a
/// relationship where both ends can be notified when either side releases the connection.
///
/// Streams can be used directly through the Channeling interface:
///
/// ```swift
/// // Create a stream with data and lifecycle handlers
/// let resource_stream = Stream(
///   source_released: { released_pulse in
///     // Handle source closing the stream
///     await resource_service.disconnect_source()
///   },
///   anchor_released: { released_pulse in
///     // Handle anchor closing the stream
///     await resource_service.release_resources()
///   },
///   handler: { pulse in
///     // Process data flowing through the stream
///     await resource_service.process(pulse.data)
///   }
/// )
///
/// // Send data through the stream
/// let result = await resource_stream.send(data_pulse)
///
/// // Release the stream when no longer needed
/// await resource_stream.release()
/// ```
final public actor Stream<Data: Pulsable>: Streaming {
  /// Unique identifier for this stream
  public let id: UUID = UUID()
  
  // Primary data pipe from source to sink
  private var data_pipe: Optional<Pipe<Data>>
  
  // Source closure notification pipe
  private var source_released_pipe: Optional<Pipe<StreamReleased>>
  
  // Anchor closure notification pipe
  private var anchor_released_pipe: Optional<Pipe<StreamReleased>>
  
  /// Creates a new stream with the specified handlers.
  ///
  /// This initializer establishes the three internal pipes that form the stream's
  /// communication infrastructure:
  /// - A data pipe for the primary message flow
  /// - Optional notification pipes for lifecycle events
  ///
  /// The notification pipes are only created if handlers are provided, allowing
  /// for efficient resource usage when full bidirectional awareness isn't needed.
  /// Each notification pipe is dedicated to a specific direction of release
  /// notification, ensuring clear separation of concerns and predictable behavior.
  ///
  /// ```swift
  /// // Create a stream with both lifecycle handlers
  /// let full_stream = Stream(
  ///   source_released: { released_pulse in
  ///     handle_source_disconnect()
  ///   },
  ///   anchor_released: { released_pulse in
  ///     handle_anchor_disconnect()
  ///   },
  ///   handler: message_processor.handle
  /// )
  ///
  /// // Create a stream with only source release notification
  /// let source_aware_stream = Stream(
  ///   source_released: { released_pulse in handle_source_disconnect() },
  ///   handler: message_processor.handle
  /// )
  ///
  /// // Create a simple stream with no lifecycle awareness
  /// let simple_stream = Stream(
  ///   handler: message_processor.handle
  /// )
  /// ```
  ///
  /// - Parameters:
  ///   - source_released: Optional handler notified when source closes the stream
  ///   - anchor_released: Optional handler notified when anchor closes the stream
  ///   - handler: Handler that processes data flowing from source to anchor
  public init(
    source_released: Optional<ChannelHandler<StreamReleased>> = .none,
    anchor_released: Optional<ChannelHandler<StreamReleased>> = .none,
    handler: @escaping ChannelHandler<Data>
  ) {
    // Create the data pipe
    self.data_pipe = Pipe(handler: handler)
    
    // Create the source closed notification pipe only if a handler is provided
    self.source_released_pipe = source_released.transform { handler in
      Pipe(handler: handler)
    }
    
    // Create the anchor closed notification pipe only if a handler is provided
    self.anchor_released_pipe = anchor_released.transform { handler in
      Pipe(handler: handler)
    }
  }
  
  /// Sends data from the source to the sink.
  ///
  /// This method forwards the provided pulse to the stream's internal data pipe
  /// for processing by the registered data handler. It follows the fire-and-forget
  /// pattern, but with additional checking for stream release status.
  ///
  /// If the stream has been released (data_pipe is nil), the method immediately
  /// returns a failure result without attempting to send the pulse. This behavior
  /// ensures that attempts to use a released stream produce consistent, predictable
  /// responses rather than unexpected errors.
  ///
  /// ```swift
  /// // Send a data pulse through the stream
  /// let result = await stream.send(data_pulse)
  ///
  /// // Check if the stream was available
  /// if case .failure(.released) = result {
  ///   // Handle the case where the stream was already released
  ///   recreate_stream_connection()
  /// }
  /// ```
  ///
  /// - Parameter pulse: The typed pulse to send through this stream
  /// - Returns: A result indicating success or a specific stream error
  @discardableResult
  public func send(_ pulse: Pulse<Data>) async -> StreamResult {
    return await data_pipe.transform { pipe in
      await pipe.send(pulse)
      return StreamResult.success
    }.otherwise(StreamResult.failure(.released))
  }
  
  /// Releases the stream, preventing further pulse processing.
  ///
  /// This method performs a complete shutdown of the stream by:
  /// 1. Checking if the stream is already released (data_pipe is nil)
  /// 2. Sending release notifications through both notification pipes (if they exist)
  ///    including the stream's unique ID both directly and via metadata
  /// 3. Clearing all pipe references to allow proper resource cleanup
  ///
  /// The release process follows a careful sequence to ensure that all notifications
  /// are sent before the data pipe is cleared, providing connected components
  /// with an opportunity to react to the stream closure.
  ///
  /// ```swift
  /// // Release a stream when it's no longer needed
  /// let result = await stream.release()
  ///
  /// if case .success = result {
  ///   // Stream was successfully released
  ///   log_event("Stream shutdown completed")
  /// } else {
  ///   // Stream was already released
  ///   log_warning("Attempted to release an already released stream")
  /// }
  /// ```
  ///
  /// - Returns: A result indicating success or a specific stream error
  @discardableResult
  public func release() async -> StreamResult {
    guard let _ = data_pipe else { return .failure(.released) }
    let release_pulse = Pulse(StreamReleased(stream_id: id)).from(self)
    
    source_released_pipe = await source_released_pipe.transform { pipe in
      await pipe.send(release_pulse)
      return .none
    }
    
    anchor_released_pipe = await anchor_released_pipe.transform { pipe in
      await pipe.send(release_pulse)
      return .none
    }
    
    data_pipe = .none
    
    return .success
  }
}
