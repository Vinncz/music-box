import AVFoundation
import Foundation



/// Interface that controls media playback with seeking capabilities.
@MainActor protocol SeekableMediaPlaybackServicing: MediaPlaybackServicing {
    
    
    /// Whether a media is loaded and ready for transport control.
    var canSeek: Bool { get }
    
    
    /// Skips part of, or return to some point on the loaded media.
    @discardableResult func seek(to seconds: TimeInterval) -> Bool
    
    
    /// Suspends automatic runtime updates to prevent slider jitter.
    func beginTimeScrubbing()
    
    
    /// Updates the current time displayed, without seeking the media.
    func updateTimeScrubbing(to time: Double)
    
    
    /// Ends time scrubbing and commit to the specified position.
    func endTimeScrubbing(at time: Double)
    
}
