// Copyright © 2025 Cassidy Spring (Bee). 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Obsidian

/// A typed message handler that delivers pulses to a registered handler function.
///
/// `Channel` provides a safe, actor-isolated mechanism for delivering strongly-typed
/// pulse messages to registered handlers. It implements a simple ownership model
/// where the component that has a reference to the channel can release it when needed.
///
/// Channels guarantee that any pulse sent to an unreleased channel will be delivered
/// to its handler, even if the handler executes asynchronously. Each delivered pulse
/// maintains its specified priority through the handling chain.
///
/// ```swift
/// // Create a channel with a handler
/// let auth_channel = Channel { pulse in
///   await process_auth_event(pulse.data)
/// }
/// ```
///
/// Channels use a fire-and-forget model for pulse delivery, spawning tasks that
/// inherit the priority of the pulse being processed. This approach ensures that
/// channel operations remain non-blocking while maintaining appropriate prioritization.
final public actor Channel<Data: Pulsable>: Channeling {
  /// Internal reference to the handler this Channel will send pulses to.
  private var handler: Optional<ChannelHandler<Data>>
  
  /// Creates a new channel with the specified handler function.
  ///
  /// This initializer creates a channel that can be released by any code
  /// with a reference to it, following Swift's standard ownership model.
  ///
  /// ```swift
  /// let event_channel = Channel { pulse in
  ///   await event_processor.handle(pulse.data)
  /// }
  /// ```
  ///
  /// - Parameter handler: The function that will process pulses sent to this channel
  public init(handler: @escaping ChannelHandler<Data>) {
    self.handler = handler
  }
  
  /// Sends a pulse to this channel for processing.
  ///
  /// This method delivers the provided pulse to the channel's registered handler
  /// function. Delivery happens asynchronously in a separate task that inherits
  /// the priority of the pulse, ensuring that high-priority pulses are processed
  /// appropriately. If the channel has been released, the operation fails with
  /// a `.released` error.
  ///
  /// ```swift
  /// let result = await channel.send(login_pulse)
  ///
  /// if case .failure(.released) = result {
  ///   // Channel was released, handle accordingly
  ///   reconnect_channel()
  /// }
  /// ```
  ///
  /// The channel guarantees that if it hasn't been released, the pulse will be
  /// delivered to the handler, even if the handler executes asynchronously.
  ///
  /// - Parameter pulse: The typed pulse to send to this channel
  /// - Returns: A result indicating success or a specific channel error
  @discardableResult
  public func send(_ pulse: Pulse<Data>) async -> ChannelResult {
    return self.handler.transform { handler in
      Task(priority: pulse.priority) { await handler(pulse) }
      return ChannelResult.success
    }.otherwise(ChannelResult.failure(.released))
  }
  
  /// Releases this channel, preventing further pulse processing.
  ///
  /// This method deactivates the channel by clearing its handler reference,
  /// preventing any further pulses from being processed.
  ///
  /// ```swift
  /// // Release a channel
  /// let result = await channel.release()
  ///
  /// if case .failure(.released) = result {
  ///   log_warning("Channel was already released")
  /// }
  /// ```
  ///
  /// If the channel has already been released, the operation fails with a
  /// `.released` error.
  ///
  /// - Returns: A result indicating success or a specific channel error
  @discardableResult
  public func release() async -> ChannelResult {
    return self.handler.transform { handler in
      self.handler = .none
      return ChannelResult.success
    }.otherwise(ChannelResult.failure(.released))
  }
  
  /// Generally the release method should be called. There are some cases where this
  /// can be relied on instead when no reference cycles are created.
  deinit {
    handler = .none
  }
}
