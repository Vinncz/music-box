import Foundation



/// One place to store global states.
actor AppState {
    
    
    /// The one instance per app lifecycle.
    static let shared = AppState()
    
    
    /// Whether SwiftData can be used to cache retrieved songs.
    var swiftDataModelContainerAvailability: Bool = false
    
    
    /// Whether KTVHTTPCache proxy is available to cache a song's 30s file preview for playback.
    var ktvHTTPCacheProxyAvailability: Bool = false
    
}



/// Extension to externally mutate actor states.
extension AppState {
    
    
    /// Self-explanatory.
    func set(swiftDataModelContainerAvailabilityTo resolve: Bool) {
        self.swiftDataModelContainerAvailability = resolve
    }
    
    
    /// Self-explanatory.
    func set(ktvHTTPCacheProxyAvailabilityTo resolve: Bool) {
        self.ktvHTTPCacheProxyAvailability = resolve
    }
    
}
