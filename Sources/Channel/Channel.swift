// Copyright © 2025 Cassidy Spring (Bee). 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Obsidian

/// A typed message handler that delivers pulses to a registered handler function.
///
/// `Channel` provides a safe, actor-isolated mechanism for delivering strongly-typed
/// pulse messages to registered handlers. It implements an ownership model where only
/// the component that created the channel can release it, ensuring that channels
/// remain active as long as needed by their owners.
///
/// Channels guarantee that any pulse sent to an unreleased channel will be delivered
/// to its handler, even if the handler executes asynchronously. Each delivered pulse
/// maintains its specified priority through the handling chain.
///
/// ```swift
/// // Create a channel with a generated key
/// let (auth_channel, auth_key) = Channel.Create { pulse in
///   await process_auth_event(pulse.data)
/// }
///
/// // Create a channel owned by a specific component
/// let profile_channel = Channel(owner: profile_service) { pulse in
///   await update_user_profile(pulse.data)
/// }
///
/// // Create a channel with a custom key
/// let custom_key = UUID()
/// let notification_channel = Channel(key: custom_key) { pulse in
///   await send_push_notification(pulse.data)
/// }
/// ```
///
/// Channels use a fire-and-forget model for pulse delivery, spawning tasks that
/// inherit the priority of the pulse being processed. This approach ensures that
/// channel operations remain non-blocking while maintaining appropriate prioritization.
final public actor Channel<Data: Pulsable> {
  /// Internal reference to the handler this Channel will send pulses to.
  private var handler: Optional<ChannelHandler<Data>>
  
  /// Internal key for release verification.
  private let key: UUID
  
  /// Creates a new channel with the specified key and handler function.
  ///
  /// This initializer creates a channel that can only be released by providing
  /// the same key used during creation, establishing a simple ownership model.
  ///
  /// ```swift
  /// let channel_key = UUID()
  /// let event_channel = Channel(key: channel_key) { pulse in
  ///   await event_processor.handle(pulse.data)
  /// }
  /// ```
  ///
  /// - Parameters:
  ///   - key: The unique identifier that authorizes channel release
  ///   - handler: The function that will process pulses sent to this channel
  public init(key: UUID, handler: @escaping ChannelHandler<Data>) {
    self.handler = handler
    self.key = key
  }
  
  /// Creates a new channel owned by a specific component.
  ///
  /// This convenience initializer uses the owner's unique identifier as the
  /// channel key, simplifying channel creation for components that already
  /// implement the `Uniquable` protocol.
  ///
  /// ```swift
  /// let service_channel = Channel(owner: auth_service) { pulse in
  ///   await process_auth_event(pulse.data)
  /// }
  /// ```
  ///
  /// - Parameters:
  ///   - owner: The component that owns this channel
  ///   - handler: The function that will process pulses sent to this channel
  public init(owner: any Uniquable, handler: @escaping ChannelHandler<Data>) {
    self.handler = handler
    self.key = owner.id
  }

  /// Creates a new channel with a generated key and returns both the channel and key.
  ///
  /// This factory method generates a new UUID to serve as the channel key, then
  /// returns both the created channel and the key. This pattern is useful when
  /// the caller needs to create and own a channel without having a pre-existing
  /// unique identifier.
  ///
  /// ```swift
  /// let (channel, key) = Channel.Create { pulse in
  ///   await process_data(pulse.data)
  /// }
  ///
  /// // Later, release the channel using the returned key
  /// await channel.release(key: key)
  /// ```
  ///
  /// - Parameter handler: The function that will process pulses sent to this channel
  /// - Returns: A tuple containing the new channel and its authorization key
  public static func Create(handler: @escaping ChannelHandler<Data>) -> (channel: Channel<Data>, key: UUID) {
    let key = UUID()
    return (Channel(key: key, handler: handler), key)
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
      return ChannelResult.success(())
    }.otherwise(ChannelResult.failure(.released))
  }

  /// Releases this channel, preventing further pulse processing.
  ///
  /// This method deactivates the channel by clearing its handler reference,
  /// preventing any further pulses from being processed. To ensure that only
  /// the channel owner can release it, the provided key must match the key
  /// used during channel creation.
  ///
  /// ```swift
  /// // Release a channel using its key
  /// let result = await channel.release(key: channel_key)
  ///
  /// switch result {
  /// case .success:
  ///   log_event("Channel successfully released")
  ///
  /// case .failure(.released):
  ///   log_warning("Channel was already released")
  ///
  /// case .failure(.invalid(let key)):
  ///   log_security_event("Invalid key used: \(key)")
  /// }
  /// ```
  ///
  /// If the channel has already been released, the operation fails with a
  /// `.released` error. If the provided key doesn't match the channel's key,
  /// the operation fails with an `.invalid` error containing the provided key.
  ///
  /// - Parameter key: The authorization key that must match the channel's key
  /// - Returns: A result indicating success or a specific channel error
  @discardableResult
  public func release(key: UUID) async -> ChannelResult {
    return self.handler.transform { handler in
      guard self.key == key else { return ChannelResult.failure(.invalid(key: key)) }
      self.handler = .none
      return ChannelResult.success(())
    }.otherwise(ChannelResult.failure(.released))
  }
  
  /// Generally the release method should be called. There are some cases where this
  /// can be relied on instead when no reference cycles are created.
  deinit {
    handler = .none
  }
}
