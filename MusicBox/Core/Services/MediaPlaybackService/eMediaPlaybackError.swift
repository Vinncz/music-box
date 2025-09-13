import Foundation



/// Errors that describe why media playback could not be enacted.
enum MediaPlaybackError: LocalizedError {
    
    
    /// Wrapper for underlying error.
    case itemFailedToLoad(Error?)
    
    
    /// Unable to retrieve media in reasonable time.
    case loadingTimedOut
    
}
