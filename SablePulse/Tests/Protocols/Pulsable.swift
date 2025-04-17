// Copyright © 2025 Cassidy Spring. 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Testing
import SableFoundation

@testable import SablePulse

@Suite("SablePulse/Protocols: Pulsable")
struct PulsableTests {
  
  // MARK: - Test Data
  
  struct TestPulse: Pulsable {
    let id: UUID
    let message: String
    let timestamp: Date
  }
  
  // MARK: - Protocol Conformance Tests
  
  @Test("conforms to Sendable")
  func conforms_to_sendable() throws {
    let is_sendable = (TestPulse.self as Any) is any Sendable.Type
    #expect(is_sendable)
  }
  
  @Test("conforms to Equatable")
  func conforms_to_equatable() throws {
    let is_equatable = (TestPulse.self as Any) is any Equatable.Type
    #expect(is_equatable)
  }
  
  @Test("conforms to Copyable")
  func conforms_to_copyable() throws {
    let is_copyable = (TestPulse.self as Any) is any Copyable.Type
    #expect(is_copyable)
  }
  
  @Test("conforms to Codable")
  func conforms_to_codable() throws {
    let is_codable = (TestPulse.self as Any) is any Codable.Type
    #expect(is_codable)
  }
  
  @Test("conforms to Hashable")
  func conforms_to_hashable() throws {
    let is_hashable = (TestPulse.self as Any) is any Hashable.Type
    #expect(is_hashable)
  }
  
  // MARK: - Encoding Tests
  
  @Test("can be encoded to JSON")
  func can_be_encoded_to_json() throws {
    // Given
    let original = TestPulse(id: UUID(), message: "Test Message", timestamp: Date())
    let encoder = JSONEncoder()
    
    // When/Then - Should not throw
    let _ = try encoder.encode(original)
  }
  
  @Test("can be decoded from JSON")
  func can_be_decoded_from_json() throws {
    // Given
    let original = TestPulse(id: UUID(), message: "Test Message", timestamp: Date())
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    // When
    let data = try encoder.encode(original)
    let decoded = try decoder.decode(TestPulse.self, from: data)
    
    // Then
    #expect(decoded.id == original.id)
    #expect(decoded.message == original.message)
    #expect(decoded.timestamp.timeIntervalSince1970 == original.timestamp.timeIntervalSince1970)
  }
  
  // MARK: - Equality Tests
  
  @Test("instances with same properties are equal")
  func instances_with_same_properties_are_equal() throws {
    // Given
    let id = UUID()
    let message = "Test Message"
    let timestamp = Date()
    
    // When
    let pulse1 = TestPulse(id: id, message: message, timestamp: timestamp)
    let pulse2 = TestPulse(id: id, message: message, timestamp: timestamp)
    
    // Then
    #expect(pulse1 == pulse2)
  }
  
  @Test("instances with different ids are not equal")
  func instances_with_different_ids_are_not_equal() throws {
    // Given
    let message = "Test Message"
    let timestamp = Date()
    
    // When
    let pulse1 = TestPulse(id: UUID(), message: message, timestamp: timestamp)
    let pulse2 = TestPulse(id: UUID(), message: message, timestamp: timestamp)
    
    // Then
    #expect(pulse1 != pulse2)
  }
  
  @Test("instances with different messages are not equal")
  func instances_with_different_messages_are_not_equal() throws {
    // Given
    let id = UUID()
    let timestamp = Date()
    
    // When
    let pulse1 = TestPulse(id: id, message: "Message 1", timestamp: timestamp)
    let pulse2 = TestPulse(id: id, message: "Message 2", timestamp: timestamp)
    
    // Then
    #expect(pulse1 != pulse2)
  }
  
  @Test("instances with different timestamps are not equal")
  func instances_with_different_timestamps_are_not_equal() throws {
    // Given
    let id = UUID()
    let message = "Test Message"
    
    // When
    let pulse1 = TestPulse(id: id, message: message, timestamp: Date())
    let pulse2 = TestPulse(id: id, message: message, timestamp: Date(timeIntervalSinceNow: 100))
    
    // Then
    #expect(pulse1 != pulse2)
  }
  
  // MARK: - Hashable Tests
  
  @Test("equal instances have same hash value")
  func equal_instances_have_same_hash_value() throws {
    // Given
    let id = UUID()
    let message = "Test Message"
    let timestamp = Date()
    
    // When
    let pulse1 = TestPulse(id: id, message: message, timestamp: timestamp)
    let pulse2 = TestPulse(id: id, message: message, timestamp: timestamp)
    
    // Then
    #expect(pulse1.hashValue == pulse2.hashValue)
  }
  
  @Test("different instances have different hash values")
  func different_instances_have_different_hash_values() throws {
    // Given
    let pulse1 = TestPulse(id: UUID(), message: "Message 1", timestamp: Date())
    let pulse2 = TestPulse(id: UUID(), message: "Message 2", timestamp: Date(timeIntervalSinceNow: 100))
    
    // When
    let hash1 = pulse1.hashValue
    let hash2 = pulse2.hashValue
    
    // Then
    #expect(hash1 != hash2)
  }
  
  @Test("can be used as dictionary key")
  func can_be_used_as_dictionary_key() throws {
    // Given
    let pulse = TestPulse(id: UUID(), message: "Test Message", timestamp: Date())
    var dictionary = [TestPulse: String]()
    
    // When
    dictionary[pulse] = "Value"
    
    // Then
    #expect(dictionary[pulse] == "Value")
  }
}
