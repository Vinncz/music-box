import Foundation
import Observation



@MainActor @Observable final class PlayerViewModel {
    
    
    /// Service that provides songs to be listed.
    var catalogService: CatalogServicing
    
    
    /// Service that provides playback capability.
    var mediaPlaybackService: SeekableMediaPlaybackServicing
    
    
    /// Service that provides caching capability.
    var mediaCachingService: MediaCacheKTVHTTPCacheService
    
    
    /// Song to be played
    var song: iTunesSong
    
    
    func play() async throws {
        let originalUrl = song.previewUrl
        let proxyUrl = await mediaCachingService.proxyURL(for: originalUrl)
        
        await mediaPlaybackService.play(url: proxyUrl)
    }
    
    
    init(catalogService: CatalogServicing, mediaPlaybackService: SeekableMediaPlaybackServicing, mediaCachingService: MediaCacheKTVHTTPCacheService, song: iTunesSong) {
        self.catalogService = catalogService
        self.mediaPlaybackService = mediaPlaybackService
        self.mediaCachingService = mediaCachingService
        self.song = song
    }
    
}
