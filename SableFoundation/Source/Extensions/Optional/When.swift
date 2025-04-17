// Copyright © 2025 Cassidy Spring. 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

extension Optional {
  
  // MARK: - When Something
  
  /// Executes a closure with the wrapped value if the optional is non-nil.
  ///
  /// This method provides a natural language alternative to optional chaining (`?.`),
  /// making code that conditionally executes based on optional presence more readable.
  ///
  /// ```swift
  /// // Using when to execute code only if value exists
  /// let user: User? = get_current_user()
  /// let greeting = user.when(something: { person in
  ///   "Hello, \(person.name)!"
  /// })
  ///
  /// // Equivalent to: let greeting = user.map { "Hello, \($0.name)!" }
  /// ```
  ///
  /// In Swift 6+, this method complements the improved optional handling features:
  /// - It provides a more readable alternative to optional chaining and map
  /// - It keeps code intention-revealing through natural language
  /// - It works seamlessly with Swift 6's improved type inference for optionals
  ///
  /// - Parameter something: A closure to execute with the wrapped value if non-nil
  /// - Returns: The result of executing the closure with the wrapped value, or nil if the optional is nil
  public func when<Result>(something: (Wrapped) -> Result) -> Result? {
    return map(something)
  }
  
  // MARK: - When Nothing
  
  /// Executes a closure if the optional is nil.
  ///
  /// This method provides a way to perform side effects when an optional is nil,
  /// without needing to use if-else or guard statements.
  ///
  /// ```swift
  /// // Execute code only when optional is nil
  /// let user: User? = get_current_user()
  /// user.when(nothing: {
  ///   analytics.log_anonymous_visit()
  /// })
  ///
  /// // Equivalent to:
  /// // if user == nil {
  /// //   analytics.log_anonymous_visit()
  /// // }
  /// ```
  ///
  /// - Parameter nothing: A closure to execute if the optional is nil
  public func when(nothing: () -> Void) {
    if self == nil {
      nothing()
    }
  }
  
  // MARK: - When Something or Nothing (returning a value)
  
  /// Executes one of two closures based on whether the optional contains a value.
  ///
  /// This method provides a natural language alternative to the nil-coalescing operator
  /// combined with map, making conditional code more readable.
  ///
  /// ```swift
  /// // Handle both the presence and absence of a value
  /// let user: User? = get_current_user()
  /// let greeting = user.when(
  ///   something: { person in
  ///     "Hello, \(person.name)!"
  ///   },
  ///   nothing: {
  ///     "Hello, Guest!"
  ///   }
  /// )
  ///
  /// // Equivalent to: let greeting = user.map { "Hello, \($0.name)!" } ?? "Hello, Guest!"
  /// ```
  ///
  /// - Parameters:
  ///   - something: A closure to execute with the wrapped value if non-nil
  ///   - nothing: A closure to execute if the optional is nil
  /// - Returns: The result of either the something or nothing closure
  public func when<Result>(
    something: (Wrapped) -> Result,
    nothing: () -> Result
  ) -> Result {
    if let wrapped = self {
      return something(wrapped)
    } else {
      return nothing()
    }
  }
  
  // MARK: - Async When Something
  
  /// Executes an async closure with the wrapped value if the optional is non-nil.
  ///
  /// This method provides an async variant of `when(something:)` for use with
  /// Swift's structured concurrency.
  ///
  /// ```swift
  /// // Using async when with actors or async code
  /// let user_id: UUID? = get_current_user_id()
  /// let user_data = await user_id.when(something: { id in
  ///   await user_service.fetch_data(for: id)
  /// })
  /// ```
  ///
  /// - Parameter something: An async closure to execute with the wrapped value if non-nil
  /// - Returns: The result of executing the closure with the wrapped value, or nil if the optional is nil
  public func when<Result>(something: (Wrapped) async -> Result) async -> Result? {
    if let wrapped = self {
      return await something(wrapped)
    } else {
      return nil
    }
  }
  
  // MARK: - Async When Nothing
  
  /// Executes an async closure if the optional is nil.
  ///
  /// This method provides an async version of `when(nothing:)` for use with
  /// Swift's structured concurrency.
  ///
  /// ```swift
  /// // Execute async code only when optional is nil
  /// let user: User? = get_current_user()
  /// await user.when(nothing: {
  ///   await analytics.log_anonymous_visit_async()
  /// })
  /// ```
  ///
  /// - Parameter nothing: An async closure to execute if the optional is nil
  public func when(nothing: () async -> Void) async {
    if self == nil {
      await nothing()
    }
  }
  
  // MARK: - Async When Something or Nothing (returning a value)
  
  /// Executes one of two async closures based on whether the optional contains a value.
  ///
  /// This method provides an async variant of `when(something:nothing:)` for use with
  /// Swift's structured concurrency.
  ///
  /// ```swift
  /// // Handle both the presence and absence of a value asynchronously
  /// let user: User? = get_current_user()
  /// let profile_data = await user.when(
  ///   something: { person in
  ///     await profile_service.fetch_profile(for: person.id)
  ///   },
  ///   nothing: {
  ///     await profile_service.fetch_default_profile()
  ///   }
  /// )
  /// ```
  ///
  /// - Note: When using this method with actors, Swift will automatically enforce
  ///   the `@Sendable` requirement at the actor boundary.
  ///
  /// - Parameters:
  ///   - something: An async closure to execute with the wrapped value if non-nil
  ///   - nothing: An async closure to execute if the optional is nil
  /// - Returns: The result of either the something or nothing closure
  public func when<Result>(
    something: (Wrapped) async -> Result,
    nothing: () async -> Result
  ) async -> Result {
    if let wrapped = self {
      return await something(wrapped)
    } else {
      return await nothing()
    }
  }
}
