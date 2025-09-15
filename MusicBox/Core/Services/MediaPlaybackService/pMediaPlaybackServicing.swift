import AVFoundation
import Foundation



/// Interface that controls media playback.
@MainActor protocol MediaPlaybackServicing {
    
    
    // MARK: -- Informations
    
    /// The state of the playback.
    var state: MediaPlaybackState { get }
    
    
    /// Current playback position of the loaded media, in seconds.
    var currentTime: Double? { get }
    
    
    /// Total duration of the loaded media.
    var totalRuntime: Double? { get }
    
    
    
    // MARK: -- Controls
    
    /// Plays the media pointed to by the given url.
    @discardableResult func play(url: URL) async -> Bool
    
    
    /// Pauses the playback of the currently-played media.
    @discardableResult func pause() async -> Bool
    
    
    /// Resumes the playback of the currently-paused media.
    @discardableResult func resume() async -> Bool
    
    
    /// Stops the playback of the loaded media.
    @discardableResult func stop() async -> Bool
    
}
