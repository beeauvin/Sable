// Copyright © 2025 Cassidy Spring (Bee). 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Obsidian

/// A typed message handler that delivers pulses to a registered handler function.
///
/// `Channel` provides a safe, actor-isolated mechanism for delivering strongly-typed
/// pulse messages to registered handlers. Built on the lightweight `Pipe` primitive,
/// it provides actor-based thread safety while maintaining high performance for
/// message delivery operations.
///
/// Channels use a fire-and-forget model for pulse delivery, spawning tasks that
/// inherit the priority of the pulse being processed. This approach ensures that
/// channel operations remain non-blocking while maintaining appropriate prioritization.
///
/// ```swift
/// // Create a channel with a handler
/// let auth_channel = Channel { pulse in
///   await process_auth_event(pulse.data)
/// }
///
/// // Send pulses through the channel
/// await auth_channel.send(login_pulse)
/// ```
///
/// ## Lifecycle Considerations
///
/// Channel lifecycle is managed through Swift's automatic reference counting. The
/// channel maintains a strong reference to its handler function, which means:
///
/// - The handler will remain alive as long as the channel exists
/// - Components referenced by the handler will not be deallocated until the channel is released
/// - Channels are ideal for long-lived services or components with coupled lifetimes
/// - For more complex lifecycle management, consider using `Stream` instead
///
/// This design makes channels perfect for simple, persistent message routing but
/// requires careful consideration when used with temporary or one-off handlers.
final public actor Channel<Data: Pulsable>: Channeling {
  /// Internal pipe that handles the actual message delivery
  private let pipe: Pipe<Data>
  
  /// Creates a new channel with the specified handler function.
  ///
  /// The channel will process all pulses sent to it using the provided handler,
  /// executing each handler call in a separate task that inherits the pulse's
  /// priority level.
  ///
  /// ```swift
  /// let event_channel = Channel { pulse in
  ///   await event_processor.handle(pulse.data)
  /// }
  /// ```
  ///
  /// - Parameter handler: The function that will process pulses sent to this channel
  public init(handler: @escaping ChannelHandler<Data>) {
    self.pipe = Pipe(handler: handler)
  }
  
  /// Sends a pulse to this channel for processing.
  ///
  /// This method delivers the provided pulse to the channel's registered handler
  /// function. Delivery happens asynchronously in a separate task that inherits
  /// the priority of the pulse, ensuring that high-priority pulses are processed
  /// appropriately.
  ///
  /// ```swift
  /// channel.send(login_pulse)
  /// ```
  ///
  /// The channel guarantees that the pulse will be delivered to the handler,
  /// with the handler executing asynchronously to maintain non-blocking behavior.
  ///
  /// - Parameter pulse: The typed pulse to send to this channel
  public nonisolated func send(_ pulse: Pulse<Data>) {
    Task.detached(priority: pulse.priority) {
      await self.pipe.send(pulse)
    }
  }
}
