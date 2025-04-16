// Copyright © 2025 Cassidy Spring. 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

/// A protocol that provides a unique identifier for an object using a UUID.
///
/// `Uniquable` extends `Identifiable` to specifically use a UUID as the identifier type.
/// This provides a standardized approach to unique identification across the Sable framework,
/// ensuring compatibility with Foundation's UUID type.
///
/// ```swift
/// struct User: Uniquable {
///   let id = UUID()
///   let name: String
/// }
///
/// let user = User(name: "Alex")
/// print(user.id) // Prints the UUID
/// ```
///
/// - Note: Types conforming to `Uniquable` automatically conform to `Identifiable`,
///   making them compatible with SwiftUI and other frameworks that leverage the
///   `Identifiable` protocol.
public protocol Uniquable: Identifiable {
  /// A unique identifier for the instance.
  ///
  /// This property distinguishes one instance from all other instances.
  var id: UUID { get }
}
