// Copyright © 2025 Cassidy Spring (Bee). 🖤 Sable Project.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import Testing
import Obsidian

@testable import Sable

@Suite("Sable/Stream/Core: Stream")
struct StreamTests {
  
  // MARK: - Test Data
  
  struct TestData: Pulsable {
    let message: String
  }
  
  func create_test_pulse() -> Pulse<TestData> {
    return Pulse(TestData(message: "Test Message"))
  }
  
  // MARK: - Initialization Tests
  
  @Test("initializes with data handler only")
  func initializes_with_handler_only() throws {
    let handler: ChannelHandler<TestData> = { _ in }
    
    let _ = Stream(handler: handler)
    
    // No assertion needed - the test passes if initialization doesn't throw
  }
  
  @Test("initializes with all handlers")
  func initializes_with_all_handlers() throws {
    let handler: ChannelHandler<TestData> = { _ in }
    let source_released: ChannelHandler<StreamReleased> = { _ in }
    let sink_released: ChannelHandler<StreamReleased> = { _ in }
    
    let _ = Stream(
      source_released: source_released,
      sink_released: sink_released,
      handler: handler
    )
    
    // No assertion needed - the test passes if initialization doesn't throw
  }
  
  // MARK: - Send Tests
  
  @Test("send delivers pulse to data handler")
  func send_delivers_pulse_to_handler() async throws {
    // Given
    let pulse = create_test_pulse()
    let expected_message = pulse.data.message
    
    // When/Then
    try await confirmation(expectedCount: 1) { (confirm) async throws -> Void in
      let handler: ChannelHandler<TestData> = { received_pulse in
        #expect(received_pulse.data.message == expected_message)
        confirm()
      }
      
      let stream = Stream(handler: handler)
      let result = await stream.send(pulse)
      try await Task.sleep(for: .milliseconds(100))
      
      if case .success = result {
        // Success case verified
      } else {
        #expect(Bool(false), "Expected success result from send")
      }
    }
  }
  
  @Test("send returns error when stream is released")
  func send_returns_error_when_stream_released() async throws {
    // Given
    let pulse = create_test_pulse()
    let handler: ChannelHandler<TestData> = { _ in }
    
    let stream = Stream(handler: handler)
    
    // When
    let release_result = await stream.release()
    if case .failure = release_result {
      #expect(Bool(false), "Stream release should have succeeded")
    }
    
    // Then
    let send_result = await stream.send(pulse)
    
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
    let handler: ChannelHandler<TestData> = { _ in }
    
    let stream = Stream(handler: handler)
    
    // When
    let result = await stream.release()
    
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
    let handler: ChannelHandler<TestData> = { _ in }
    
    let stream = Stream(handler: handler)
    
    // When
    let first_result = await stream.release()
    if case .failure = first_result {
      #expect(Bool(false), "First stream release should have succeeded")
    }
    
    // Then
    let second_result = await stream.release()
    
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
  
  // MARK: - Notification Tests
  
  @Test("release notifies source released handler")
  func release_notifies_source_released() async throws {
    // When/Then
    try await confirmation(expectedCount: 1) { (confirm) async throws -> Void in
      let handler: ChannelHandler<TestData> = { _ in }
      
      let source_released: ChannelHandler<StreamReleased> = { _ in
        confirm()
      }
      
      let stream = Stream(
        source_released: source_released,
        handler: handler
      )
      
      let _ = await stream.release()
      try await Task.sleep(for: .milliseconds(100))
    }
  }
  
  @Test("release notifies sink released handler")
  func release_notifies_sink_released() async throws {
    // When/Then
    try await confirmation(expectedCount: 1) { (confirm) async throws -> Void in
      let handler: ChannelHandler<TestData> = { _ in }
      
      let sink_released: ChannelHandler<StreamReleased> = { _ in
        confirm()
      }
      
      let stream = Stream(
        sink_released: sink_released,
        handler: handler
      )
      
      let _ = await stream.release()
      try await Task.sleep(for: .milliseconds(100))
    }
  }
  
  @Test("release notifies both handlers")
  func release_notifies_both_handlers() async throws {
    // When/Then
    try await confirmation(expectedCount: 2) { (confirm) async throws -> Void in
      let handler: ChannelHandler<TestData> = { _ in }
      
      let source_released: ChannelHandler<StreamReleased> = { _ in
        confirm()
      }
      
      let sink_released: ChannelHandler<StreamReleased> = { _ in
        confirm()
      }
      
      let stream = Stream(
        source_released: source_released,
        sink_released: sink_released,
        handler: handler
      )
      
      let _ = await stream.release()
      try await Task.sleep(for: .milliseconds(100))
    }
  }
}
