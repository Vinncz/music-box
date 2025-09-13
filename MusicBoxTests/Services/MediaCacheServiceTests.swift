import Foundation
import KTVHTTPCache
import Testing
@testable import MusicBox



@Suite(.serialized)
struct MediaCacheServiceTests {
    
    
    /**
     IMPORTANT
     
     Run the cases individually due to the static nature of KTV.
     */
    
    @Test("Service is able to start. DISABLE `wakeServices` on `MusicBoxApp.swift` to pass.")
    func testStartup() async throws {
        let mediaCacheService = MediaCacheKTVHTTPCacheService()
        try #require(await mediaCacheService.start())
        
        await mediaCacheService.stop()
    }
    
    
    @Test("URLSession's data(for:) are cached")
    func testCacheFunctionality() async throws {
        let service = MediaCacheKTVHTTPCacheService()
        try #require(await service.start())
        
        // 0) Setups
        await service.clearCache()
        let originalUrl = URL.beatlesYellowSubmarineOriginalMix30sPreview
        
        // 1) Retrieve the proxy representation of the real URL
        let proxyUrl = await service.proxyURL(for: originalUrl)
        
        // 2) Fetch the content through the proxyUrl using URLSession
        let request = URLRequest(url: proxyUrl)
        _ = try await URLSession.shared.data(for: request)
        
        // 3) Wait until cache has been finalized
        try await Task.sleep(for: .seconds(Constants.TIMEOUT))
        
        // 4) Verify the cache to contain the response for the originalUrl
        let completeResponse = try #require(await service.completeResponseURL(for: originalUrl))
        
        // 5) Verify the cache to be accessible
        #expect(FileManager.default.fileExists(atPath: completeResponse.path))
        
        // 6) Cleanup for next test
        await service.stop()
    }
    
    
    @Test("Partial cache hits and preloading are handled correctly")
    func testPartialCacheHits() async throws {
        let service = MediaCacheKTVHTTPCacheService()
        try #require(await service.start())
        
        // 0) Setup
        await service.clearCache()
        let originalUrl = URL.beatlesYellowSubmarineOriginalMix30sPreview
        
        // 1) Preload the first n-seconds of preview
        await service.preload(firstSeconds: 1, bitrate: .ITUNES_SAMPLE_BITRATE, for: originalUrl)
        
        // 2) Wait until cache has been finalized
        try await Task.sleep(for: .seconds(Constants.TIMEOUT))
        
        // 3) Verify the cache is partial
        let partialCacheLength = KTVHTTPCache.cacheCacheItem(with: originalUrl).cacheLength
        #expect(partialCacheLength > 0, "Cache is present--though not at all complete")
        #expect(await service.completeResponseURL(for: originalUrl) == nil, "Not complete yet")
        
        // 4) Fetch the rest of the media
        let proxyUrl = await service.proxyURL(for: originalUrl)
        _ = try await URLSession.shared.data(for: URLRequest(url: proxyUrl))
        
        // 5) VERIFICATION POINT 1 -- CHECK CONSOLE as the rest of the media is loaded in
        try await Task.sleep(for: .seconds(Constants.TIMEOUT))
        
        // 6) VERIFICATION POINT 2 -- The full cached response should be there
        _ = try #require(await service.completeResponseURL(for: originalUrl))
        
        let fullCacheLength = KTVHTTPCache.cacheCacheItem(with: originalUrl).totalLength
        #expect(fullCacheLength > partialCacheLength)
        
        // 7) Cleanup for next test
        await service.stop()
    }
    
    
    @Test("Canceling preloads work correctly")
    func testCancelPreloading() async throws {
        let service = MediaCacheKTVHTTPCacheService()
        try #require(await service.start())
        
        // 0) Setup
        await service.clearCache()
        let originalUrl = URL.beatlesYellowSubmarineOriginalMix30sPreview
        
        // 1) Preload the first n-seconds of preview
        await service.preload(firstSeconds: 10, bitrate: .ITUNES_SAMPLE_BITRATE, for: originalUrl)
        
        // 2) Confirm preloader is active
        #expect(await service.preloaderCount() == 1)
        
        // 3) Wait for the download to begin
        try await Task.sleep(for: .seconds(2))
        
        // 4) Cancel the preload
        await service.cancelPreload(for: originalUrl)
        
        // 5) Verify the preloader was removed
        #expect(await service.preloaderCount() == 0)
        
        // 6) Verify the cache stops growing
        let lengthAfterCancel = KTVHTTPCache.cacheCacheItem(with: originalUrl).cacheLength
        try await Task.sleep(for: .seconds(2))
        let lengthAfterWaiting = KTVHTTPCache.cacheCacheItem(with: originalUrl).cacheLength
        
        #expect(lengthAfterCancel == lengthAfterWaiting)
        
        // 7) Cleanup for next test
        await service.stop()
    }
    
}
