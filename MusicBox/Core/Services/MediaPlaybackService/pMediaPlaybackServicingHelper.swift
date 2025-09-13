import Foundation



protocol MediaPlaybackServicingHelper {
    
    
    /// Fetches the first n-second of the media for better selecting experience.
    func preload(firstSeconds: TimeInterval, bitrate: Double, for url: URL) async
    
    
    /// Cancels the ongoing (or pending) preload operations.
    func cancelPreload(for url: URL) async
    
}
