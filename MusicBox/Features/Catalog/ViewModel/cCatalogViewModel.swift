import Foundation
import Observation
import OSLog



@MainActor @Observable final class CatalogViewModel {
    
    
    /// Service that provides songs to be listed.
    var catalogService: CatalogServicing
    
    
    /// Service that provides playback capability.
    var mediaPlaybackService: MediaPlaybackServicing
    
    
    /// Service that provides caching capability.
    var mediaCachingService: MediaCacheKTVHTTPCacheService
    
    
    /// Songs to be listed
    var songs: [iTunesSong]
    
    
    /// Search query
    var query: String = "beatles" {
        didSet { debounce() }
    }
    
    
    /// Initializes the view model for CatalogView.
    init(catalogService: CatalogServicing, 
         mediaPlaybackService: MediaPlaybackServicing, 
         mediaCachingService: MediaCacheKTVHTTPCacheService) {
        self.catalogService = catalogService
        self.mediaPlaybackService = mediaPlaybackService
        self.mediaCachingService = mediaCachingService
        self.songs = []
    }
    
    
    /// Coordinates with the `catalogService` to update the listed songs.
    func refresh() async {
        do {
            let songs = try await catalogService.search(
                term: query.sanitizedForURL, 
                country: Constants.REGION, 
                media: .music, 
                entity: .song, 
                limit: 50, 
                explicit: true
            )
            
            Task { @MainActor in
                self.songs = songs
            }
            
        } catch {
            Logger.viewCycle.error("Error refreshing catalog: \(error)")
        }
    }
    
    
    /// Task for the purpose of debouncing.
    private var searchTask: Task<Void, Never>?
    
    
    /// Debounces the search action.
    private func debounce() {
        self.searchTask?.cancel()
        self.searchTask = Task {
            try? await Task.sleep(for: .seconds(Constants.DEBOUNCE_COOLDOWN))
            guard !Task.isCancelled else { return }
            Task { @MainActor in
                await refresh()
            }
        }
    }
    
    
    /// Convenience function to preload musics.
    func preload(songUrl: URL) async {
        await mediaCachingService.preload(
            firstSeconds: Constants.PRELOAD_THRESHOLD, 
            bitrate: .ITUNES_SAMPLE_BITRATE, 
            for: songUrl
        )
    }
    
    
    /// Convenience function to cancel preloading musics.
    func cancelPreload(songUrl: URL) async {
        await mediaCachingService.cancelPreload(for: songUrl)
    }
    
}
