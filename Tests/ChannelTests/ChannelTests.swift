// Copyright © 2025 Cassidy Spring (Bee). 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Testing
import Obsidian

@testable import Sable

@Suite("Sable/Channel/Core: Channel")
struct ChannelTests {
  
  // MARK: - Test Data
  
  struct TestPulseData: Pulsable {
    let message: String
  }
  
  func create_test_pulse() -> Pulse<TestPulseData> {
    return Pulse(TestPulseData(message: "Test Message"))
  }
  
  // MARK: - Initialization Tests
  
  @Test("initializes with handler")
  func initializes_with_handler() throws {
    // Given
    let handler: ChannelHandler<TestPulseData> = { _ in }
    
    // When
    let _ = Channel(handler: handler)
    
    // Then
    // If initialization failed, this would have thrown an error
    // No assertion needed - the test passes if no error is thrown
  }
  
  // MARK: - Send Tests
  
  @Test("send delivers pulse to handler")
  func send_delivers_pulse_to_handler() async throws {
    // Given
    let pulse = create_test_pulse()
    let expected_message = pulse.data.message
    
    // When/Then
    try await confirmation(expectedCount: 1) { (confirm) async throws -> Void in
      let handler: ChannelHandler<TestPulseData> = { received_pulse in
        #expect(received_pulse.data.message == expected_message)
        confirm()
      }
      
      let channel = Channel(handler: handler)
      channel.send(pulse)
      try await Task.sleep(for: .milliseconds(100))
    }
  }
  
  @Test("send processes multiple pulses")
  func send_processes_multiple_pulses() async throws {
    // Given
    let pulse1 = Pulse(TestPulseData(message: "First"))
    let pulse2 = Pulse(TestPulseData(message: "Second"))
    let pulse3 = Pulse(TestPulseData(message: "Third"))
    
    // When/Then
    try await confirmation(expectedCount: 3) { (confirm) async throws -> Void in
      let handler: ChannelHandler<TestPulseData> = { received_pulse in
        // Verify we received one of the expected messages
        let message = received_pulse.data.message
        #expect(["First", "Second", "Third"].contains(message))
        confirm()
      }
      
      let channel = Channel(handler: handler)
      
      channel.send(pulse1)
      channel.send(pulse2)
      channel.send(pulse3)
      
      try await Task.sleep(for: .milliseconds(100))
    }
  }
  
  @Test("handler retains references as documented")
  func handler_retains_references_as_documented() async throws {
    // Given
    weak var weak_service: TestService?
    let pulse = create_test_pulse()
    
    // When
    let channel = {
      let service = TestService()
      weak_service = service
      
      let handler: ChannelHandler<TestPulseData> = { _ in
        // Reference the service to create a retention cycle
        await service.process_message()
      }
      
      return Channel(handler: handler)
    }()
    
    // Then - service should still be alive because channel retains the handler
    #expect(weak_service != nil, "Service should be retained by channel's handler")
    
    // Clean up
    channel.send(pulse)
    try await Task.sleep(for: .milliseconds(100))
  }

  // MARK: - Task Priority Tests
  
  @Test("send creates task with pulse priority")
  func send_creates_task_with_pulse_priority() async throws {
    // Given
    let pulse = create_test_pulse().priority(.high)
    
    // When/Then
    try await confirmation(expectedCount: 1) { (confirm) async throws -> Void in
      let handler: ChannelHandler<TestPulseData> = { _ in
        let current_priority = Task.currentPriority
        #expect(current_priority == .high)
        confirm()
      }
      
      let channel = Channel(handler: handler)
      channel.send(pulse)
      try await Task.sleep(for: .milliseconds(100))
    }
  }
  
  @Test("send preserves different priority levels")
  func send_preserves_different_priority_levels() async throws {
    // Given
    let low_pulse = create_test_pulse().priority(.low)
    let high_pulse = create_test_pulse().priority(.high)
    
    // When/Then
    try await confirmation(expectedCount: 2) { (confirm) async throws -> Void in
      let handler: ChannelHandler<TestPulseData> = { received_pulse in
        let current_priority = Task.currentPriority
        let expected_priority = received_pulse.priority
        #expect(current_priority == expected_priority)
        confirm()
      }
      
      let channel = Channel(handler: handler)
      channel.send(low_pulse)
      channel.send(high_pulse)
      try await Task.sleep(for: .milliseconds(100))
    }
  }
  
  // MARK: - Helper Types
  
  actor TestService {
    func process_message() async {
      // Simulate some work
      try? await Task.sleep(for: .milliseconds(10))
    }
  }
}
