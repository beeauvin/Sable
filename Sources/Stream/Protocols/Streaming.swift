// Copyright © 2025 Cassidy Spring (Bee). 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Obsidian

/// A protocol that defines the core operations for stream-like components.
///
/// `Streaming` extends the basic `Channeling` interface with identity capabilities
/// through `Representable` conformance, enabling streams to be uniquely identified
/// and referenced throughout the system. This combination provides both the core
/// messaging operations and the identity information needed for stream lifecycle
/// management and debugging.
///
/// Streams differ from channels in their intended usage patterns:
/// - Channels provide simple unidirectional message delivery
/// - Streams establish bidirectional relationships with lifecycle awareness
/// - Streams can be identified and referenced by their unique identity
///
/// The protocol inherits the core messaging operations from `Channeling`:
/// - `send(_:)` for delivering typed pulses to handlers
/// - `release()` for closing the stream and preventing further processing
///
/// And adds identity capabilities from `Representable`:
/// - Unique identification through `id` property
/// - Human-readable naming through `name` property
/// - Consistent description formatting
///
/// This design enables building more sophisticated stream-based architectures
/// while maintaining compatibility with existing channel-based code through
/// the shared `Channeling` interface.
/// ```
public protocol Streaming<Data>: Channeling, Representable where Data: Pulsable {}
