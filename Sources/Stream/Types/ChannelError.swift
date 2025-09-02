// Copyright © 2025 Cassidy Spring (Bee). 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Obsidian

/// Represents specific error conditions that can occur during stream operations.
///
/// `StreamError` encapsulates the primary failure mode for stream operations:
/// attempting to interact with a stream that has been released.
///
/// This error is returned as part of a `StreamResult` rather than thrown,
/// aligning with Sable's design principle of non-throwing code. This approach
/// encourages explicit error handling and predictable control flow.
///
/// ```swift
/// // Handle stream errors in a switch statement
/// switch result {
/// case .success:
///   continue_processing()
///
/// case .failure(.released):
///   reconnect_stream()
/// }
/// ```
///
/// The error case is designed to provide just enough context for proper error
/// handling without exposing unnecessary implementation details.
@frozen public enum StreamError: Error {
  /// Indicates that the stream has been released and can no longer process pulses.
  ///
  /// This error occurs when attempting to send a pulse to a stream that has been
  /// explicitly released, or when attempting to release a stream that has
  /// already been released.
  case released
}
