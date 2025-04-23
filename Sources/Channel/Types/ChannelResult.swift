// Copyright © 2025 Cassidy Spring (Bee). 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

/// Type alias representing the result of a channel operation.
///
/// `ChannelResult` provides a standardized way to handle the outcome of operations
/// performed on a channel, such as sending a pulse or releasing a channel. The Result
/// type encapsulates either success (Void) or failure with a specific ChannelError.
///
/// Using Result instead of throwing functions aligns with Sable's design principle
/// of non-throwing code, allowing for explicit error handling patterns that are both
/// predictable and composable.
///
/// ```swift
/// // Process a channel operation result
/// let result = await channel.send(pulse)
///
/// switch result {
/// case .success:
///   // Operation succeeded
///   break
///
/// case .failure(.released):
///   // Channel was already released
///   handle_released_channel()
///
/// case .failure(.invalid(let key)):
///   // Invalid key was provided
///   log_invalid_key_error(key)
/// }
/// ```
///
/// Channel operations typically return this result type, allowing callers
/// to determine whether the operation completed successfully or encountered
/// a specific error condition.
public typealias ChannelResult = Result<Void, ChannelError>
