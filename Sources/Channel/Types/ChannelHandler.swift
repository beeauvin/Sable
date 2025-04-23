// Copyright © 2025 Cassidy Spring (Bee). 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

/// Type alias that defines a handler function for processing pulses within a channel.
///
/// `ChannelHandler` represents an asynchronous function that consumes pulses through
/// a channel. Each handler:
/// - Takes a strongly-typed pulse as input
/// - Executes asynchronously to ensure non-blocking operations
/// - Returns nothing (Void), focusing exclusively on processing the pulse
/// - Conforms to Sendable to enable safe concurrent execution across actor boundaries
///
/// Channel handlers are designed to be registered with a channel to process all
/// pulses sent through that specific channel. They act as the terminal processor in a
/// pulse's journey through the messaging system.
///
/// ```swift
/// // Define a simple handler that logs pulse information
/// let logging_handler: ChannelHandler<LoginEvent> = { pulse in
///   await logger.log("Received login event: \(pulse.data.user_id)")
/// }
///
/// // Define a handler that forwards pulses to another system
/// let forwarding_handler: ChannelHandler<SystemEvent> = { pulse in
///   await external_system.process(pulse)
/// }
/// ```
///
/// Handlers automatically inherit the priority of the pulse being processed,
/// ensuring that high-priority pulses receive appropriately prioritized handling.
public typealias ChannelHandler<Data: Pulsable> = @Sendable (Pulse<Data>) async -> Void
