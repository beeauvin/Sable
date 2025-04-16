// Copyright © 2025 Cassidy Spring. 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import SableFoundation
import Testing

@testable import SablePulse

@Suite("SablePulse/Protocols: Pulsable")
struct PulsableTests {
  
  // Test structure that conforms to Pulsable
  struct TestPulse: Pulsable {
    let id: UUID
    let message: String
    let timestamp: Date
  }
  
  @Test("Pulsable conforms to Sendable")
  func pulsable_conforms_to_sendable() throws {
    // Given
    let is_sendable = (TestPulse.self as Any) is any Sendable.Type
    
    // Then
    #expect(is_sendable)
  }
  
  @Test("Pulsable conforms to Equatable")
  func pulsable_conforms_to_equatable() throws {
    // Given
    let is_equatable = (TestPulse.self as Any) is any Equatable.Type
    
    // Then
    #expect(is_equatable)
  }
  
  @Test("Pulsable conforms to Copyable")
  func pulsable_conforms_to_copyable() throws {
    // Given
    let is_copyable = (TestPulse.self as Any) is any Copyable.Type
    
    // Then
    #expect(is_copyable)
  }
  
  @Test("Pulsable conforms to Codable")
  func pulsable_conforms_to_codable() throws {
    // Given
    let is_codable = (TestPulse.self as Any) is any Codable.Type
    
    // Then
    #expect(is_codable)
  }
  
  @Test("Pulsable conforms to Hashable")
  func pulsable_conforms_to_hashable() throws {
    // Given
    let is_hashable = (TestPulse.self as Any) is any Hashable.Type
    
    // Then
    #expect(is_hashable)
  }
  
  @Test("Pulsable instances can be encoded and decoded")
  func pulsable_instances_can_be_encoded_and_decoded() throws {
    // Given
    let original = TestPulse(id: UUID(), message: "Test Message", timestamp: Date())
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    // When
    let data = try encoder.encode(original)
    let decoded = try decoder.decode(TestPulse.self, from: data)
    
    // Then
    #expect(decoded == original)
  }
  
  @Test("Different Pulsable instances are not equal")
  func different_pulsable_instances_are_not_equal() throws {
    // Given
    let pulse1 = TestPulse(id: UUID(), message: "Message 1", timestamp: Date())
    let pulse2 = TestPulse(id: UUID(), message: "Message 2", timestamp: Date(timeIntervalSinceNow: 100))
    
    // Then
    #expect(pulse1 != pulse2)
  }
  
  @Test("Pulsable instances have unique hash values")
  func pulsable_instances_have_unique_hash_values() throws {
    // Given
    let pulse1 = TestPulse(id: UUID(), message: "Message 1", timestamp: Date())
    let pulse2 = TestPulse(id: UUID(), message: "Message 2", timestamp: Date(timeIntervalSinceNow: 100))
    
    // When
    let hash1 = pulse1.hashValue
    let hash2 = pulse2.hashValue
    
    // Then
    #expect(hash1 != hash2)
  }
}
