// Copyright © 2025 Cassidy Spring. 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

/// A protocol that combines unique identification, naming, and description capabilities.
///
/// `Representable` unifies the `Uniquable`, `Namable`, and `Describable` protocols
/// to provide a complete representation for an object. This creates a standardized
/// way to identify, name, and describe types throughout the Sable framework.
///
/// By default, a `Representable` object's description will be its name followed by
/// its UUID, separated by a colon.
///
/// ```swift
/// struct User: Representable {
///   let id = UUID()
///   // Uses default implementations for name and description
/// }
///
/// struct CustomUser: Representable {
///   let id = UUID()
///   let name: String
///
///   // Description will still use the default implementation: "\(name):\(id)"
/// }
///
/// let user = User()
/// print(user.name)        // Prints "User"
/// print(user.description) // Prints "User:73A67C13-ABCD-1234-EFGH-456789ABCDEF"
/// ```
///
/// - Note: Types conforming to `Representable` automatically conform to
///   `Uniquable`, `Namable`, and `Describable`, gaining all their functionality.
public protocol Representable: Uniquable, Namable, Describable {}

extension Representable {
  /// Default implementation of description that combines name and ID.
  ///
  /// Returns a string with the format: "\(name):\(id)"
  public var description: String {
    return "\(name):\(id)"
  }
}
