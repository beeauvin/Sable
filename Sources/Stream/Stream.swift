// Copyright © 2025 Cassidy Spring (Bee). 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Obsidian

/// A communication pathway with built-in bidirectional lifecycle awareness. Built on
/// `Channel` for chain-of-trust primitives.
///
/// `Stream` extends Sable's messaging architecture by providing a connection between
/// components with mutual awareness of lifecycle events. Unlike a regular `Channel`,
/// which offers unidirectional fire-and-forget messaging, a `Stream` establishes a
/// relationship where both ends can be notified when either side releases the connection.
///
/// This bidirectional lifecycle awareness enables components to properly clean up resources,
/// disconnect dependencies, or switch to alternative communication paths when a connection
/// is lost. The `Stream` conforms to `Channeling` to enable seamless integration with
/// existing channel-based architectures.
///
/// Key features:
/// - Unique identification through UUID for stream tracking in complex systems
/// - Bidirectional lifecycle awareness through notification channels
/// - Type-safe data passing with Pulse encapsulation
/// - Actor isolation for thread safety
/// - Conformance to `Channeling` for interoperability with regular channels
/// - Clean resource management when streams are released
///
/// Streams maintain three internal channels:
/// - A primary data channel for the main message flow
/// - Two notification channels for lifecycle events (source release and sink release)
///
/// This architecture enables robust connection management in distributed systems where
/// components need to react appropriately when their communication partners disconnect.
///
/// Example usage:
///
/// ```swift
/// // Create a stream with data and lifecycle handlers
/// let resource_stream = Stream(
///   data_handler: { pulse in
///     // Process data flowing through the stream
///     await resource_service.process(pulse.data)
///   },
///   source_released_handler: { released_pulse in
///     // Handle source closing the stream
///     // Can access released_pulse.stream_id directly or
///     // released_pulse.meta.source.id for the same information
///     await resource_service.disconnect_source()
///   },
///   sink_released_handler: { released_pulse in
///     // Handle sink closing the stream
///     await resource_service.release_resources()
///   }
/// )
///
/// // Send data through the stream
/// let result = await resource_stream.send(data_pulse)
///
/// // Release the stream when no longer needed
/// await resource_stream.release()
/// ```
final public actor Stream<Data: Pulsable>: Channeling, Representable {
  /// Unique identifier for this stream
  ///
  /// This ID allows for proper identification of the stream in release notifications
  /// and enables tracking in systems that manage multiple streams, such as Deltas.
  public let id: UUID = UUID()
  
  // Primary data channel from source to sink
  private var data_channel: Optional<Channel<Data>>
  
  // Source closure notification channel
  private var source_released_channel: Optional<Channel<StreamReleased>>
  
  // Sink closure notification channel
  private var sink_released_channel: Optional<Channel<StreamReleased>>
  
  /// Creates a new stream with the specified handlers.
  ///
  /// This initializer establishes the three internal channels that form the stream's
  /// communication infrastructure:
  /// - A data channel for the primary message flow
  /// - Optional notification channels for lifecycle events
  ///
  /// The notification channels are only created if handlers are provided, allowing
  /// for efficient resource usage when full bidirectional awareness isn't needed.
  /// Each notification channel is dedicated to a specific direction of release
  /// notification, ensuring clear separation of concerns and predictable behavior.
  ///
  /// ```swift
  /// // Create a stream with both lifecycle handlers
  /// let full_stream = Stream(
  ///   data_handler: message_processor.handle,
  ///   source_released_handler: { released_pulse in
  ///     // Can access the stream ID through both:
  ///     // released_pulse.stream_id (direct)
  ///     // released_pulse.meta.source.id (metadata)
  ///     handle_source_disconnect()
  ///   },
  ///   sink_released_handler: { released_pulse in
  ///     handle_sink_disconnect()
  ///   }
  /// )
  ///
  /// // Create a stream with only source release notification
  /// let source_aware_stream = Stream(
  ///   data_handler: message_processor.handle,
  ///   source_released_handler: { released_pulse in handle_source_disconnect() }
  /// )
  ///
  /// // Create a simple stream with no lifecycle awareness
  /// let simple_stream = Stream(
  ///   data_handler: message_processor.handle
  /// )
  /// ```
  ///
  /// - Parameters:
  ///   - data_handler: Handler that processes data flowing from source to sink
  ///   - source_released_handler: Optional handler notified when source closes the stream
  ///   - sink_released_handler: Optional handler notified when sink closes the stream
  public init(
    data_handler: @escaping ChannelHandler<Data>,
    source_released_handler: Optional<ChannelHandler<StreamReleased>> = .none,
    sink_released_handler: Optional<ChannelHandler<StreamReleased>> = .none
  ) {
    // Create the data channel
    self.data_channel = Channel(handler: data_handler)
    
    // Create the source closed notification channel only if a handler is provided
    self.source_released_channel = source_released_handler.transform { handler in
      Channel(handler: handler)
    }
    
    // Create the sink closed notification channel only if a handler is provided
    self.sink_released_channel = sink_released_handler.transform { handler in
      Channel(handler: handler)
    }
  }
  
  /// Sends data from the source to the sink.
  ///
  /// This method forwards the provided pulse to the stream's internal data channel
  /// for processing by the registered data handler. It follows the same pattern as
  /// Channel's send method, but with additional checking for stream release status.
  ///
  /// If the stream has been released (data_channel is nil), the method immediately
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
  /// - Returns: A result indicating success or a specific channel error
  @discardableResult
  public func send(_ pulse: Pulse<Data>) async -> ChannelResult {
    return await data_channel.transform { channel in
      return await channel.send(pulse)
    }.otherwise(.failure(.released))
  }
  
  /// Releases the stream, preventing further pulse processing.
  ///
  /// This method performs a complete shutdown of the stream by:
  /// 1. Checking if the stream is already released (data_channel is nil)
  /// 2. Sending release notifications through both notification channels (if they exist)
  ///    including the stream's unique ID both directly and via metadata
  /// 3. Releasing all three internal channels
  /// 4. Clearing the channel references to allow proper resource cleanup
  ///
  /// The release process follows a careful sequence to ensure that all notifications
  /// are sent before the data channel is released, providing connected components
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
  /// - Returns: A result indicating success or a specific channel error
  @discardableResult
  public func release() async -> ChannelResult {
    guard let _ = data_channel else { return .failure(.released) }
    let release_pulse = Pulse(StreamReleased(stream_id: id)).from(self)
    
    source_released_channel = await source_released_channel.transform { channel in
      await channel.send(release_pulse)
      await channel.release()
      return .none
    }
    
    sink_released_channel = await sink_released_channel.transform { channel in
      await channel.send(release_pulse)
      await channel.release()
      return .none
    }
    
    data_channel = await data_channel.transform { channel in
      await channel.release()
      return .none
    }
    
    return .success
  }
}
