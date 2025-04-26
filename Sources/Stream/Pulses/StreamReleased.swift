// Copyright © 2025 Cassidy Spring (Bee). 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

/// Represents a stream lifecycle event indicating that a stream has been released.
///
/// `StreamReleased` is a simple event type used internally by the `Stream` system to
/// notify handlers when a stream endpoint has been released. It contains no payload data,
/// as the event itself is the message - the stream connection has been terminated.
///
/// This type conforms to `Pulsable` to enable it to be sent through channels as part
/// of the stream lifecycle notification system. The static factory method `pulse()`
/// provides a convenient way to create fully-formed pulse messages containing this event.
///
/// Example usage within the Stream system:
///
/// ```swift
/// // Send a stream released notification
/// await notification_channel.send(StreamReleased.pulse())
/// ```
@frozen public struct StreamReleased: Pulsable {
  /// Creates a new pulse containing a StreamReleased event.
  ///
  /// This factory method creates a fully-configured pulse containing a
  /// StreamReleased event.
  ///
  /// ```swift
  /// // Create and send a stream released notification
  /// let release_pulse = StreamReleased.pulse()
  /// await notification_channel.send(release_pulse)
  /// ```
  ///
  /// - Returns: A new pulse containing a StreamReleased event
  static func pulse() -> Pulse<StreamReleased> {
    return Pulse(StreamReleased())
  }
}
