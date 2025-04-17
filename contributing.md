# Contributing to Sable

Thank you for your interest in contributing to Sable! This document outlines our development
practices and guidelines to ensure consistency across the codebase.

## Getting Started

1. Fork and clone the repository
2. Read through this guide to understand our coding and testing standards
3. Make your changes in a feature branch
4. Run tests to ensure everything passes
5. Submit a pull request with a clear description of your changes

## Code Style

Sable follows specific style guidelines:

- We use 2-space indentation (configured in `.swift-format`)
- All variables and functions use `snake_case` rather than Swift's conventional camelCase
- Public APIs should have comprehensive documentation comments
- Natural language interfaces are preferred over symbolic operations where appropriate

## Testing Standards

Testing is a critical part of Sable's development process. We aim for thorough test coverage with
clean, readable tests that follow these guidelines:

### General Test Principles

1. **Single-Behavior Tests**: Each test should test exactly one behavior or assertion
2. **Consistent Naming**: All test methods use `snake_case` and clearly describe what's being tested
3. **Isolation**: Tests should be independent and not rely on side effects from other tests
4. **Public API Focus**: Tests should primarily test public behavior, not implementation details

Internal functionality (code that is marked `internal`) is considered public for rule 4. Still not
implementation details but internally (to the project) used apis are just as important to test.

### Test Organization

1. Organize tests into logical sections using `// MARK: - Section Name` comments
2. Use sections that have meaning and relevance to the code being tested.

### Test Structure

Follow the Given/When/Then pattern in tests:

```swift
@Test("descriptive test name")
func descriptive_test_method_name() throws {
  // Given - Set up test prerequisites
  let test_data = create_test_data()
  
  // When - Perform the action being tested
  let result = some_function(test_data)
  
  // Then - Verify the expected outcome
  #expect(result == expected_value)
}
```

### Test Helper Methods

- Create helper methods to reduce duplication in test setup
- Keep these methods focused and simple
- Document their purpose clearly

### Example Test File

```swift
@Suite("ModuleName/ComponentName")
struct ComponentTests {
  
  // MARK: - Test Data
  
  struct TestData: Pulsable {
    let value: String
  }
  
  func create_test_data() -> TestData {
    return TestData(value: "Test Value")
  }
  
  // MARK: - Protocol Conformance Tests
  
  @Test("conforms to Protocol")
  func conforms_to_protocol() throws {
    let is_conforming = (Component.self as Any) is any Protocol.Type
    #expect(is_conforming)
  }
  
  // MARK: - Initialization Tests
  
  @Test("initializes with default values")
  func initializes_with_default_values() throws {
    let component = Component()
    #expect(component.property == default_value)
  }
  
  // Additional test sections as needed...
}
```

### Separation of Concerns

- Core functionality tests should be in the main component test file
- Extension functionality should be tested in dedicated extension test files
- All files must have a matching test file for their public APIs.
- Don't duplicate tests across files

## Pull Request Process

1. Ensure your code adheres to the style and testing guidelines
2. Update documentation if you're changing public APIs
3. Take exceptionally extra care to point out breaking changes
4. Add or update tests to cover your changes
5. Run the test suite to verify all tests pass
6. Submit your pull request with a clear description of:
   - What changes you've made
   - Why you made them
   - Any potential side effects

## Code of Conduct

We follow the [Contributor Covenant](https://www.contributor-covenant.org) code of conduct. Please
be respectful and considerate in all interactions.

## License

By contributing to Sable, you agree that your contributions will be licensed under the project's
[Mozilla Public License 2.0](https://mozilla.org/MPL/2.0/).
