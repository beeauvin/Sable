// Copyright © 2025 Cassidy Spring. 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

/// A protocol that provides a textual description of an object.
///
/// `Describable` offers a consistent way to get a human-readable description
/// of types across the Sable framework. This can be used for logging, debugging,
/// or displaying information to users.
///
/// ```swift
/// struct Message: Describable {
///   let sender: String
///   let content: String
///
///   var description: String {
///     return "\(sender): \(content)"
///   }
/// }
///
/// let message = Message(sender: "Alice", content: "Hello!")
/// print(message.description)  // Prints "Alice: Hello!"
/// ```
///
/// - Note: Unlike Swift's `CustomStringConvertible` protocol, `Describable` is designed
///   to be used explicitly when a description is needed, rather than implicitly through
///   string interpolation or printing.
@available(*, deprecated, message: "Use Obsidian (https://github.com/beeauvin/Obsidian) instead.")
public protocol Describable {
  /// A textual description of the instance.
  ///
  /// This property should provide a concise but informative description,
  /// suitable for logging, debugging, or user-facing displays.
  var description: String { get }
}
