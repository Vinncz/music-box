import AVFoundation
import Foundation
import Testing
@testable import MusicBox



@Suite(.serialized)
struct MediaPlaybackServiceTests {
    
    
    @Test("Player won't play gibberish remote URL")
    func testGibberishURL() async throws {
        Task { @MainActor in
            guard let url = URL(string: "https://example.com") else {
                preconditionFailure("URL is invalid")
            }
            
            let service = MediaPlaybackService()
            #expect(await service.play(url: url))
        }
    }
    
    
    @Test("Player always play working remote URL")
    func testWorkingURL() async throws {
        Task { @MainActor in
            let service = MediaPlaybackService()
            #expect(await service.play(url: .beatlesYellowSubmarineOriginalMix30sPreview))
            #expect(await service.play(url: .beatlesYellowSubmarine2022Mix30sPreview))
            #expect(await service.play(url: .beatlesYellowSubmarine2023Mix30sPreview))
        }
    }
    
    
    @Test("Player support full media lifecycle")
    func testPlayerMediaLifecycle() async throws {
        Task { @MainActor in
            let service: MediaPlaybackServicing = MediaPlaybackService()
            await service.play(url: .beatlesYellowSubmarineOriginalMix30sPreview)
            
            if case .playing = service.state {
                precondition(true, "")
            } else {
                preconditionFailure("Service isn't playing when its supposed to")
            }
            
            await service.pause()
            if case .paused = service.state {
                precondition(true, "")
            } else {
                preconditionFailure("Service isn't paused when its supposed to")
            }
            
            await service.resume()
            if case .playing = service.state {
                precondition(true, "")
            } else {
                preconditionFailure("Service isn't playing when its supposed to")
            }
            
            await service.stop()
            try #require(service.state == .idle)
        }
    }
    
}
