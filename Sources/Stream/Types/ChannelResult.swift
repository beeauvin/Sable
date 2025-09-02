// Copyright © 2025 Cassidy Spring (Bee). 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Obsidian

/// Type alias representing the result of a stream operation.
///
/// `StreamResult` provides a standardized way to handle the outcome of operations
/// performed on a stream, such as sending a pulse or releasing a stream. The Result
/// type encapsulates either success (Void) or failure with a specific StreamError.
///
/// Using Result instead of throwing functions aligns with Sable's design principle
/// of non-throwing code, allowing for explicit error handling patterns that are both
/// predictable and composable.
///
/// ```swift
/// // Process a stream operation result
/// let result = await stream.send(pulse)
///
/// switch result {
/// case .success:
///   // Operation succeeded
///   break
///
/// case .failure(.released):
///   // Stream was already released
///   handle_released_stream()
/// }
/// ```
///
/// Stream operations that can fail return this result type, allowing callers
/// to determine whether the operation completed successfully or encountered
/// a specific error condition.
public typealias StreamResult = Result<Void, StreamError>
