// Copyright © 2025 Cassidy Spring. 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import SableFoundation

/// 🖤 SablePulse provides type-safe message primitives for building event-based systems.
///
/// As part of the Sable framework, SablePulse offers immutable, strongly-typed
/// message containers called "pulses" with rich metadata that can be used for
/// implementing messaging systems. Built on Swift's actor model and structured
/// concurrency, it ensures that message data is properly formed and thread-safe,
/// ready to be transported through your application's own messaging infrastructure.
///
/// ## Core Features
///
/// - **Type-Safe Messaging**: Full generic type support without any type erasure
/// - **Actor-Ready Concurrency**: Built specifically for Swift's actor system
/// - **Natural Language API**: Expressive, readable method names that form cohesive sentences
/// - **Immutable Message Design**: All operations produce new message instances
/// - **Comprehensive Metadata**: Rich operational context that travels with messages
/// - **Tracing & Causality**: Built-in support for tracing message flows and causality chains
/// - **Memory Safety**: Designed with proper resource lifecycle management
/// - **Debugging Support**: Debug-specific features to enhance visibility during development
///
/// ## Basic Usage
///
/// ```swift
/// // Define message types
/// struct UserLoggedIn: Pulsable {
///   let user_id: UUID
///   let timestamp: Date
/// }
///
/// // Create and customize a pulse
/// let pulse = Pulse(UserLoggedIn(user_id: user.id, timestamp: Date()))
///   .priority(.high)
///   .tagged("auth", "security")
///   .from(auth_service)
///
/// // Create a response pulse
/// let response = Pulse.Respond(
///   to: pulse,
///   with: AuthenticationCompleted(success: true, user_id: user.id)
/// )
/// ```
///
/// See the SablePulse documentation for detailed information on using
/// the messaging system within your application.
public enum SablePulse {}
