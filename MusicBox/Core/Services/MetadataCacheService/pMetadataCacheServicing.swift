import Foundation



/// Interface that controls the facade of metadata caching.
protocol MetadataCacheServicing {
    
    
    /// Fetches metadata stored from the last active session.
    func retrieve() async throws -> [iTunesSong]
    
    
    /// Stores the metadata from the current session for better app-launch experience.
    func store(_ songs: [iTunesSong], replacingExisting: Bool) async throws
    
}
