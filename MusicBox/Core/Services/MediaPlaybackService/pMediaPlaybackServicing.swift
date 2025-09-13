import AVFoundation
import Foundation



/// Interface that controls media playback.
@MainActor protocol MediaPlaybackServicing {
    
    
    var state: MediaPlaybackState { get }
    
    
    /// Plays the media pointed to by the given url.
    func play(url: URL) async throws
    
    
    /// Pauses the playback of the currently-played media.
    func pause() async
    
    
    /// Resumes the playback of the currently-paused media.
    func resume() async
    
    
    /// Stops the playback of the loaded media.
    func stop() async
    
}
