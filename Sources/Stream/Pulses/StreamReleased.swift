// Copyright © 2025 Cassidy Spring (Bee). 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Obsidian

/// Represents a stream lifecycle event indicating that a stream has been released.
///
/// `StreamReleased` is a simple event type used internally by the `Stream` system to
/// notify handlers when a stream endpoint has been released. It contains the stream's
/// unique identifier, allowing for proper stream identification in multi-stream systems.
///
/// This type conforms to `Pulsable` to enable it to be sent through channels as part
/// of the stream lifecycle notification system.
///
/// The stream identity is provided in two complementary ways:
/// - Directly via the `stream_id` property for immediate access
/// - Through pulse metadata as the source, accessible via `pulse.meta.source`
///
/// This dual approach provides both self-documentation and framework consistency.
///
/// Example usage within the Stream system:
///
/// ```swift
/// // Send a stream released notification
/// await notification_channel.send(Pulse(StreamReleased(stream_id: self.id)).from(self))
/// ```
@frozen public struct StreamReleased: Pulsable {
  /// The unique identifier of the stream that was released
  public let stream_id: UUID
}
