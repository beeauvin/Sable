// Copyright © 2025 Cassidy Spring (Bee). 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Obsidian

/// Represents specific error conditions that can occur during channel operations.
///
/// `ChannelError` encapsulates the two primary failure modes for channel operations:
/// - When attempting to interact with a channel that has been released
/// - When attempting to release a channel with an invalid authorization key
///
/// These errors are returned as part of a `ChannelResult` rather than thrown,
/// aligning with Sable's design principle of non-throwing code. This approach
/// encourages explicit error handling and predictable control flow.
///
/// ```swift
/// // Handle channel errors in a switch statement
/// switch result {
/// case .success:
///   continue_processing()
///
/// case .failure(.released):
///   reconnect_channel()
///
/// case .failure(.invalid(let key)):
///   log_security_event("Invalid key used: \(key)")
/// }
/// ```
///
/// The error cases are designed to provide just enough context for proper error
/// handling without exposing unnecessary implementation details.
@frozen public enum ChannelError: Error {
  /// Indicates that the channel has been released and can no longer process pulses.
  ///
  /// This error occurs when attempting to send a pulse to a channel that has been
  /// explicitly released, or when attempting to release a channel that has
  /// already been released.
  case released
  
  /// Indicates that an invalid key was provided when attempting to release a channel.
  ///
  /// To prevent unauthorized release of channels, a security key must be provided
  /// that matches the key used during channel creation. This error includes the
  /// invalid key that was provided, which can be useful for security auditing.
  ///
  /// - Parameter key: The invalid UUID that was provided during the release attempt
  case invalid(key: UUID)
}
