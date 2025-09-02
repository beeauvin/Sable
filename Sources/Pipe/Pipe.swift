// Copyright © 2025 Cassidy Spring (Bee). 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Obsidian

/// A lightweight message delivery primitive for internal use within Sable actors.
///
/// `Pipe` is the foundational struct that powers both `Channel` and `Stream` by providing
/// efficient, priority-aware message delivery. It holds a handler function and spawns
/// appropriately prioritized tasks to execute that handler when pulses are sent.
///
/// Pipes are designed to be owned and used exclusively within actor boundaries, relying
/// on their owning actor to provide thread safety. They have no mutable state and no
/// lifecycle management - they simply deliver messages until they're deallocated along
/// with their owner.
///
/// ```swift
/// // Internal usage within an actor
/// private let data_pipe = Pipe { pulse in
///   await process_data(pulse.data)
/// }
///
/// // Send a pulse through the pipe
/// await data_pipe.send(user_pulse)
/// ```
///
/// The pipe automatically inherits the priority of each pulse, ensuring that high-priority
/// messages receive appropriate scheduling treatment in Swift's task system.
internal struct Pipe<Data: Pulsable>: Sendable {
  /// The handler function that processes pulses sent through this pipe
  private let handler: ChannelHandler<Data>
  
  /// Creates a new pipe with the specified handler function.
  ///
  /// The pipe will process all pulses sent to it using the provided handler,
  /// spawning a new task for each pulse that inherits the pulse's priority level.
  ///
  /// - Parameter handler: The function that will process pulses sent through this pipe
  internal init(handler: @escaping ChannelHandler<Data>) {
    self.handler = handler
  }
  
  /// Sends a pulse through this pipe for processing.
  ///
  /// This method spawns a new task with the pulse's priority level and executes
  /// the handler function asynchronously. The operation is fire-and-forget,
  /// ensuring that pipe operations remain non-blocking.
  ///
  /// - Parameter pulse: The typed pulse to send through this pipe
  internal func send(_ pulse: Pulse<Data>) async {
    Task(priority: pulse.priority) { await handler(pulse) }
  }
}
