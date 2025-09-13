import AVFoundation
import Foundation
import Testing
@testable import MusicBox



struct MediaPlaybackServiceTests {
    
    
    @Test("Player won't play gibberish remote URL")
    func testGibberishURL() async throws {
        guard let url = URL(string: "https://example.com") else {
            preconditionFailure("URL is invalid")
        }
        
        let service = await MediaPlaybackService()
        await #expect(throws: MediaPlaybackError.self) {
            try await service.play(url: url)
        }
    }
    
    
    @Test("Player always play working remote URL")
    func testWorkingURL() async throws {
        let service = await MediaPlaybackService()
        await #expect(throws: Never.self) {
            try await service.play(url: .beatlesYellowSubmarineOriginalMix30sPreview)
            try await service.play(url: .beatlesYellowSubmarine2022Mix30sPreview)
            try await service.play(url: .beatlesYellowSubmarine2023Mix30sPreview)
        }
    }
    
    
    @Test("Player support full media lifecycle")
    func testPlayerMediaLifecycle() async throws {
        let service: MediaPlaybackServicing = await MediaPlaybackService()
        try await service.play(url: .beatlesYellowSubmarineOriginalMix30sPreview)
        
        if case .playing = await service.state {
            precondition(true, "")
        } else {
            preconditionFailure("Service isn't playing when its supposed to")
        }
        
        await service.pause()
        if case .paused = await service.state {
            precondition(true, "")
        } else {
            preconditionFailure("Service isn't paused when its supposed to")
        }
        
        await service.resume()
        if case .playing = await service.state {
            precondition(true, "")
        } else {
            preconditionFailure("Service isn't playing when its supposed to")
        }
        
        await service.stop()
        try await #require(service.state == .idle)
    }
    
}
