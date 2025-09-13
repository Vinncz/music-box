import KTVHTTPCache
import SwiftUI
import SwiftData
import OSLog



@main
struct MusicBoxApp: App {
    
    
    /// Provides the catalog that iTunes offer.
    @State var catalogService: CatalogServicing
    
    
    /// Controls the media playback.
    @State var mediaPlaybackService: MediaPlaybackServicing
    
    
    /// Caches the 30s file preview.
    @State var mediaCacheService: MediaCacheKTVHTTPCacheService
    
    
    /// Bootstraps the app.
    init() { 
        self.catalogService = CatalogService()
        self.mediaPlaybackService = MediaPlaybackService()
        self.mediaCacheService = MediaCacheKTVHTTPCacheService()
    }
    
    
    var body: some Scene {
        WindowGroup { 
            CatalogView(viewModel: 
                CatalogViewModel(catalogService: catalogService, 
                                 mediaPlaybackService: mediaPlaybackService, 
                                 mediaCachingService: mediaCacheService
            ))
            .task {
               _ = try? await mediaCacheService.start()
            }
        }
    }
}



fileprivate extension MusicBoxApp {
    
    
    func wakeServices() {
        
    }
    
}
