import AVFoundation
import Foundation
import Observation
import OSLog



/// Controls the one and only AVPlayer for playback, 
/// and communicates via the ``MediaPlaybackServicing`` protocol.
/// 
/// Placed on the main actor so every AVPlayer interactions occur on the main thread.
@MainActor @Observable 
final class MediaPlaybackService: MediaPlaybackServicing {
    
    
    /// Source of truth for media playback state.
    private(set) var state: MediaPlaybackState = .idle
    
    
    /// The underlying AVPlayer that does the media playback.
    private var player: AVPlayer?
    
    
    /// Observes the playability of the media pointed to by the url.
    private var mediaStatusObserver: NSKeyValueObservation?
    
    
    /// Observes the playback of the player.
    private var bufferObserver: NSKeyValueObservation?
    
    
    /// 'Receipt' for subscription to `NotificationCenter`.
    private var didFinishObserver: NSObjectProtocol?
    
    
    /// Asynchronously loads and plays media from the given URL.
    func play(url: URL) async throws {
        
        // 1) New media require clean service slate.
        reset()
        
        // 2) Load or fail the media early.
        state = .loading(url)
        Logger.playback.info("Attempting to load media from \(url)")
        
        let playerItem = AVPlayerItem(url: url)
        let player = AVPlayer(playerItem: playerItem)
        self.player = player
        
        // 3) Make sure the player can play it.
        try await awaitStatus(for: playerItem)
        
        // 4) Instruct the player to play, and what should happen after it is done.
        setupObservers(for: player, url: url)
        self.player?.play()
        self.state = .playing(url)
        
        Logger.playback.info("Started media playback for \(url)")
    }
    
    
    /// Temporarily halts the playback of the ``loadedMediaUrl``.
    func pause() {
        guard case let .playing(url) = state else {
            return
        }
        
        self.player?.pause()
        self.state = .paused(url)
        
        Logger.playback.info("Paused media playback for \(url)")
    }
    
    
    /// Resumes the playback of the ``loadedMediaUrl``.
    /// 
    /// - Note:
    ///   If the current media has finished playing, 
    ///   invoking ``resume`` will replay the media from the beginning.
    func resume() {
        switch state {
        case let .paused(url):
            self.player?.play()
            self.state = .playing(url)
                
            Logger.playback.info("Resumed media playback for \(url)")
            
        case let .finished(url):
            Task { [weak self] in
                await self?.player?.seek(to: .zero)
                self?.player?.play()
                self?.state = .playing(url)
                
                Logger.playback.info("Replayed media from beginning for \(url)")
            }
        
        default:
            Logger.playback.warning("No media loaded. Unable to resume.")
        }
    }
    
    
    /// Ends the playback and dereferences the previously-running AVPlayer.
    func stop() {
        guard state != .idle else {
            Logger.playback.warning("No media loaded. Unable to stop.")
            return
        }
        
        reset()
        Logger.playback.warning("Stopped media playback.")
    }
    
}



/// Helper methods extension.
fileprivate extension MediaPlaybackService {
    
    
    /// Resets the service back to pristine condition.
    /// 
    /// Use this `reset` method to clear states between one media playback from the other.
    func reset() {
        player?.pause()
        player = nil
        
        self.mediaStatusObserver?.invalidate()
        self.mediaStatusObserver = nil
        
        if let didFinishObserver {
            NotificationCenter.default.removeObserver(didFinishObserver)
            self.didFinishObserver = nil
        }
        
        state = .idle
    }
    
    
    /// Determines whether media pointed in the URL can be played, 
    /// should it not have been resolved already.
    /// 
    /// ABSTRACT: 
    /// A KVO-observation in Swift 6's async world, with a timeout.
    func awaitStatus(for playerItem: AVPlayerItem) async throws {
        if case .readyToPlay = playerItem.status { return }
        if case .failed = playerItem.status { throw MediaPlaybackError.itemFailedToLoad(playerItem.error) }
        
        try await withThrowingTaskGroup(of: Void.self) { group in
            
            // 1) Timeout assurance
            group.addTask {
                try await Task.sleep(for: .seconds(Constants.TIMEOUT))
                throw MediaPlaybackError.loadingTimedOut
            }
            
            // 2) Resolve the playability status of the media
            group.addTask {
                try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                    
                    // Status has been resolved. No need to execute no further.
                    guard playerItem.status == .unknown else {
                        if playerItem.status == .failed {
                            continuation.resume(throwing: MediaPlaybackError.itemFailedToLoad(playerItem.error))
                        } else {
                            continuation.resume()
                        }
                        return
                    }
                    
                    // Observe status changes
                    Task { @MainActor in 
                        self.set(mediaStatusObserver: playerItem.observe(\.status, options: .new) { [self] item, _ in
                            Task { @MainActor in self.mediaStatusObserver?.invalidate() }
                            
                            switch item.status {
                            case .readyToPlay:
                                continuation.resume()
                            case .failed:
                                Task { @MainActor in
                                    self.state = .failed(playerItem.asset.description, 
                                                         item.error ?? URLError(.unknown))
                                }
                                continuation.resume(throwing: MediaPlaybackError.itemFailedToLoad(item.error))
                            default:
                                break
                            }
                        })
                    }
                }
            }
            
            // 3) Whether the status is resolved within `Constant.TIMEOUT` time, or fails.
            do {
                try await group.next()
                group.cancelAll()
                
            } catch {
                group.cancelAll()
                throw error
            }
        }
    }
    
    
    /// Set up observers for buffering operations and eof.
    func setupObservers(for player: AVPlayer, url: URL) {
        self.bufferObserver = player.observe(\.timeControlStatus, options: .new) { [weak self] player, _ in
            guard let self = self else { return }
            
            switch player.timeControlStatus {
            case .paused:
                break
            
            case .playing:
                Task { @MainActor in self.set(state: .playing(url)) }
                    
            case .waitingToPlayAtSpecifiedRate:
                Task { @MainActor in self.set(state: .buffering(url)) }
                    
            @unknown default:
                break
            }
        }
        
        self.didFinishObserver = NotificationCenter.default.addObserver(
            forName: AVPlayerItem.didPlayToEndTimeNotification, 
            object: player.currentItem, 
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            
            Logger.playback.info("Media has finished playing.")
            Task { @MainActor in self.state = .finished(url) }
        }
    }
    
    
    /// Enables outside mutation on `mediaStatusObserver`.
    func set(mediaStatusObserver: NSKeyValueObservation) {
        self.mediaStatusObserver = mediaStatusObserver
    }
    
    
    /// Enables outside mutation on `state`.
    func set(state: MediaPlaybackState) {
        self.state = state
    }
    
}
