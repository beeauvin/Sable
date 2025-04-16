// Copyright © 2025 Cassidy Spring. 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

/// A protocol that defines requirements for types that can be sent through the Pulse messaging system.
///
/// `Pulsable` combines several Swift protocol conformances to ensure that types can be:
/// - Safely passed between threads and actors (`Sendable`)
/// - Compared for equality (`Equatable`)
/// - Duplicated as needed (`Copyable`)
/// - Serialized and deserialized (`Codable`)
/// - Used as dictionary keys or in sets (`Hashable`)
///
/// These requirements ensure that pulse messages can be safely transmitted across thread
/// boundaries, cached, compared, persisted, and used in collections throughout the Sable framework.
///
/// ```swift
/// struct UserLoggedIn: Pulsable {
///   let user_id: UUID
///   let timestamp: Date
/// }
///
/// struct SettingsChanged: Pulsable {
///   let settings: [String: Any]
///   let changed_by: UUID
/// }
/// ```
///
/// - Note: By conforming to all these protocols, `Pulsable` types are guaranteed to work
///   correctly within the actor-based messaging architecture of Sable. This enables
///   compile-time safety for cross-thread communication.
public protocol Pulsable: Sendable, Equatable, Copyable, Codable, Hashable {}
