import Foundation
import KTVHTTPCache
import OSLog



/// Facades the underlying KTVHTTPCahce that caches every URL
actor MediaCacheKTVHTTPCacheService {
    
    
    /// Pairings of data loaders and urls, where the former fetches from the latter. 
    /// 
    /// Due to the nature of actors, DispatchQueue is not needed to sequentially
    /// queue the loaders to start fetching.
    private var preloaders: [URL: KTVHCDataLoader] = [:]
    
    
    /// Whether the service and its underlying layer is functional.
    var isRunning: Bool = false
    
    
    /// Prepares the underlying layer to function correctly.
    init() {
        KTVHTTPCache.logSetConsoleLogEnable(true)
        KTVHTTPCache.encodeSetURLConverter { url in
            guard let url else { return nil }
            
            var disectedComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            
            let excludedAuthParams = disectedComponents?.queryItems?.filter { $0.name.lowercased() != "token" }
            disectedComponents?.queryItems = excludedAuthParams
            
            return disectedComponents?.url ?? url
        }
    }

    
    /// Starts the service and the underlying layers that make the service possible.
    /// 
    /// - Important:
    ///   Fails when started twice.
    func start() throws -> Bool {
        do {
            try KTVHTTPCache.proxyStart()
            self.isRunning = true
            Logger.network.info("KTVHTTPCache started normally.")
            return true
            
        } catch {
            self.isRunning = false
            Logger.network.error("KTVHTTPCache failed to start. No file caching will be performed. Error: \(error)")
            
            throw error
        }
    }
    
    
    /// Stops the service and the underlying layers that make the service possible.
    func stop() {
        KTVHTTPCache.proxyStop()
        self.isRunning = false
        Logger.network.info("KTVHTTPCache stopped.")
    }
    
}



/// Convenience functions for URL-cache handlings.
extension MediaCacheKTVHTTPCacheService {
    
    
    /// Maps the original url to point to cache instead.
    func proxyURL(for original: URL, withAirplaySupport airplayRequired: Bool = false) -> URL {
        airplayRequired
        ? KTVHTTPCache.proxyURL(withOriginalURL: original, bindToLocalhost: false)
        : KTVHTTPCache.proxyURL(withOriginalURL: original)
    }
    
    
    /// Returns the URL to the cached response if present, nil otherwise.
    func completeResponseURL(for original: URL) -> URL? {
        KTVHTTPCache.cacheCompleteFileURL(with: original)
    }
    
}



/// Conformance extension to ``MediaPlaybackServicingHelper``.
extension MediaCacheKTVHTTPCacheService: MediaPlaybackServicingHelper {
    
    
    /// Request the first n-bytes of data from some URL.
    func preload(firstSeconds seconds: TimeInterval, bitrate: Double, for url: URL) {
        let bytes = Int((bitrate / 8.0) * seconds)
        let headers = ["Range": "bytes=0-\(max(0, bytes))"]
        let request = KTVHCDataRequest(url: url, headers: headers)
        
        if let loader = KTVHTTPCache.cacheLoader(with: request) {
            loader.prepare()
            preloaders[url] = loader
            
            Logger.network.info("Preload successfully placed for \(url)")
            
        } else {
            Logger.network.error("Preload failed for \(url)")
            
        }
    }
    
    
    /// Cancels the preload action for the specified URL.
    func cancelPreload(for url: URL) {
        preloaders[url]?.close()
        preloaders[url] = nil
        
        Logger.network.info("Preload canceled for \(url).")
    }
    
}



#if DEBUG
/// Convenience test helper methods extension.
extension MediaCacheKTVHTTPCacheService {
    
    
    /// Returns the number of active preloaders. For testing only.
    func preloaderCount() -> Int {
        self.preloaders.count
    }
    
    
    /// Clears the entire on-disk cache. For testing only.
    func clearCache() {
        KTVHTTPCache.cacheDeleteAllCaches()
    }
    
}
#endif
