import Foundation



/// The atomic state of a media playback.
/// Use this enum as the single source of truth for UIs.
enum MediaPlaybackState: Equatable {
    
    
    /// Player is not loaded.
    case idle
    
    
    /// Player is resolving media contained within the URL. 
    case loading(URL)
    
    
    /// Player is waiting for enough buffer to be played, while media is being streamed in.
    case buffering(URL)
    
    
    /// Player is actively playing media located in the URL.
    case playing(URL)
    
    
    /// Player is halted in making a playback of the media at the given URL.
    case paused(URL)
    
    
    /// Player has reached the end of the media at the given URL.
    case finished(URL)
    
    
    /// Player is unable to play the media at the given URL, alongside the cause.
    case failed(String, Error)
    
    
    /// Evaluates whether the given state are one and the same.
    /// 
    /// - Important:
    ///   Errors are NOT compared.
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): return true
        case let (.loading(lhs), .loading(rhs)): return lhs == rhs
        case let (.buffering(lhs), .buffering(rhs)): return lhs == rhs
        case let (.playing(lhs), .playing(rhs)): return lhs == rhs
        case let (.paused(lhs), .paused(rhs)): return lhs == rhs
        case let (.finished(lhs), .finished(rhs)): return lhs == rhs
        case let (.failed(lhs, _), .failed(rhs, _)): return lhs == rhs
        default: return false
        }
    }
    
}
