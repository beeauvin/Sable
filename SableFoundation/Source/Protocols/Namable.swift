// Copyright © 2025 Cassidy Spring. 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Foundation

/// A protocol that provides a name for an object.
///
/// `Namable` provides a consistent way to access a human-readable name
/// for types across the Sable framework. By default, it returns the type name
/// as a string, but conforming types can override this with a custom name.
///
/// ```swift
/// struct Product: Namable {
///   // Uses default implementation: returns "Product"
/// }
///
/// struct CustomProduct: Namable {
///   let name: String  // Custom implementation: returns this value
///
///   init(name: String) {
///     self.name = name
///   }
/// }
///
/// let product = Product()
/// print(product.name)  // Prints "Product"
///
/// let custom = CustomProduct(name: "Deluxe Widget")
/// print(custom.name)   // Prints "Deluxe Widget"
/// ```
///
/// - Note: The default implementation returns the type name without parentheses,
///   using `String(describing: type(of: self))` rather than `String(describing: self)`.
///   This provides a cleaner representation for logging and debugging.
public protocol Namable {
  /// A human-readable name for the instance.
  ///
  /// By default, this returns the type name as a string (e.g., "ClassName" or "GenericClass<Type>").
  /// Conforming types can override this property to provide a custom name.
  var name: String { get }
}

extension Namable {
  /// Default implementation that returns the type name as a string.
  ///
  /// This implementation uses `String(describing: type(of: self))` to get the
  /// type name without parentheses, for a cleaner representation.
  public var name: String {
    return String(describing: type(of: self))
  }
}
