import KTVHTTPCache
import SwiftUI
import SwiftData
import OSLog



@main
struct MusicBoxApp: App {
    
    
    /// Performs critical tasks upon initialization.
    init() { startKTVHTTPCache() }
    
    
    @State var playbackService = MediaPlaybackService()
    @State var shouldShowFileImporter = false
    
    var body: some Scene {
        WindowGroup { 
            Text("\(playbackService.state)")
            
            Button("Import") {
                shouldShowFileImporter = true
            }
            .fileImporter(isPresented: $shouldShowFileImporter, allowedContentTypes: [.audio]) { result in
                switch result {
                case let .success(url):
                    _ = url.startAccessingSecurityScopedResource()
                    Task {
                        try await playbackService.play(url: url)
                    }
                case let .failure(error):
                    print("Error importing \(error)")
                }
            }
            
            if case .playing = playbackService.state {
                Button("Pause") {
                    playbackService.pause()
                }.buttonStyle(.borderedProminent)
            } else {
                Button("Resume") {
                    playbackService.resume()
                }.buttonStyle(.borderedProminent)
            }
            
            Button("Stop") {
                playbackService.stop()
            }.buttonStyle(.borderedProminent)
        }
        .modelContainer(for: [iTunesSong.self], inMemory: false) { startupResult in 
            if case let .failure(reason) = startupResult {
                Logger.cache.error("ModelContainer failed to initialize. No metadata will be cached. Error: \(reason)")
                return
            }
            
            Logger.cache.info("ModelContainer initialized normally.")
            Task { await AppState.shared.set(swiftDataModelContainerAvailabilityTo: true) }
        }
    }
}



fileprivate extension MusicBoxApp {
    
    
    func startKTVHTTPCache() {
        do {
            try KTVHTTPCache.proxyStart()
            KTVHTTPCache.logSetConsoleLogEnable(true)
            Logger.network.info("KTVHTTPCache started normally.")
            Task { await AppState.shared.set(ktvHTTPCacheProxyAvailabilityTo: true) }
            
        } catch {
            Logger.network.error("KTVHTTPCache failed to start. No file caching will be performed. Error: \(error)")
        }
    }
    
}
