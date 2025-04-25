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
      let result = await channel.send(pulse)
      try await Task.sleep(for: .milliseconds(100))
      
      if case .success = result {
        // Success case verified
      } else {
        #expect(Bool(false), "Expected success result from send")
      }
    }
  }
  
  @Test("send returns error when channel is released")
  func send_returns_error_when_channel_released() async throws {
    // Given
    let pulse = create_test_pulse()
    let handler: ChannelHandler<TestPulseData> = { _ in }
    
    let channel = Channel(handler: handler)
    
    // When
    let release_result = await channel.release()
    if case .failure = release_result {
      #expect(Bool(false), "Channel release should have succeeded")
    }
    
    // Then
    let send_result = await channel.send(pulse)
    
    if case .failure(let error) = send_result {
      if case .released = error {
        // Success - got the released error as expected
      } else {
        #expect(Bool(false), "Expected released error but got different error")
      }
    } else {
      #expect(Bool(false), "Expected failure result from send")
    }
  }
  
  // MARK: - Release Tests
  
  @Test("release succeeds")
  func release_succeeds() async throws {
    // Given
    let handler: ChannelHandler<TestPulseData> = { _ in }
    
    let channel = Channel(handler: handler)
    
    // When
    let result = await channel.release()
    
    // Then
    if case .success = result {
      // Success case verified
    } else {
      #expect(Bool(false), "Expected success result from release")
    }
  }
  
  @Test("release fails when already released")
  func release_fails_when_already_released() async throws {
    // Given
    let handler: ChannelHandler<TestPulseData> = { _ in }
    
    let channel = Channel(handler: handler)
    
    // When
    let first_result = await channel.release()
    if case .failure = first_result {
      #expect(Bool(false), "First channel release should have succeeded")
    }
    
    // Then
    let second_result = await channel.release()
    
    if case .failure(let error) = second_result {
      if case .released = error {
        // Success - got the released error as expected
      } else {
        #expect(Bool(false), "Expected released error but got different error")
      }
    } else {
      #expect(Bool(false), "Expected failure result from second release")
    }
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
      let _ = await channel.send(pulse)
      try await Task.sleep(for: .milliseconds(100))
    }
  }
}
