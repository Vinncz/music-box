import AVFoundation
import Foundation
import Observation
import OSLog



/// Controls the one and only AVPlayer for playback, 
/// and communicates via the ``MediaPlaybackServicing`` protocol.
/// 
/// Placed on the main actor so every AVPlayer interactions occur on the main thread.
@MainActor @Observable 
final class MediaPlaybackService: SeekableMediaPlaybackServicing {
    
    
    // MARK: -- Publicly Available Information
    
    /// The state of the playback.
    private(set) var state: MediaPlaybackState = .idle
    
    
    /// Current playback position of the loaded media, in seconds.
    private(set) var currentTime: Double?
    
    
    /// Total duration of the loaded media.
    private(set) var totalRuntime: Double?
    
    
    
    // MARK: -- Internal Implementation
    
    /// The underlying AVPlayer that does the media playback.
    private var player: AVPlayer?
    
    
    /// Observes the playability of the media pointed to by the url.
    private var playabilityObserver: NSKeyValueObservation?
    
    
    /// Observes whether the playback is hindered due to buffering.
    private var bufferObserver: NSKeyValueObservation?
    
    
    /// Observes whether the media has finished playing.
    private var mediaFinishedPlayingObserver: NSObjectProtocol?
    
    
    /// Observes for the position of the playback pointer against the played media. 
    private var playbackTimeObserver: Any?
    
    
    /// Whether the seekbar is currently being scrubbed.
    private var isScrubbing: Bool = false
    
}



/// Base capability methods extension.
extension MediaPlaybackService {
    
    
    /// Plays the media pointed to by the given url.
    func play(url: URL) async -> Bool {
        
        // 1) New media require clean service slate.
        self.reset()
        
        // 2) Load or fail the media early.
        self.state = .loading(url)
        Logger.playback.info("Attempting to load media from \(url)")
        
        let playerItem = AVPlayerItem(url: url)
        let player = AVPlayer(playerItem: playerItem)
        self.player = player
        
        do {
            // 3a) Make sure the player can play it.
            try await awaitStatus(for: playerItem)
            
            // 4) Instruct the player to play, and what should happen after it is done.
            self.setupObservers(for: player, url: url)
            self.player?.play()
            self.state = .playing(url)
            
            Logger.playback.info("Started media playback for \(url)")
            return true
            
        } catch {
            // 3b) Revert the playback state.
            self.state = .idle
            
            Logger.playback.error("Failed to load media from \(url): \(error)")
            return false
        }
    }
    
    
    /// Pauses the playback of the currently-played media.
    func pause() -> Bool {
        guard case let .playing(url) = state else {
            return false
        }
        
        self.player?.pause()
        self.state = .paused(url)
        
        Logger.playback.info("Paused media playback for \(url)")
        return true
    }
    
    
    /// Resumes the playback of the currently-paused media.
    /// 
    /// - Note:
    ///   If the current media has finished playing, 
    ///   invoking ``resume()`` will replay the media from the beginning.
    func resume() -> Bool {
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
            return false
        }
        
        return true
    }
    
    
    /// Stops the playback of the loaded media.
    func stop() -> Bool {
        guard state != .idle else {
            Logger.playback.warning("No media loaded. Unable to stop.")
            return false
        }
        
        reset()
        Logger.playback.warning("Stopped media playback.")
        return true
    }
    
}



/// Seekable capability methods extension.
extension MediaPlaybackService {
    
    
    /// Whether a media is loaded and ready for transport control.
    var canSeek: Bool {
        switch state {
        case .playing, .paused, .finished, .buffering: return true
        default: return false
        }
    }
    
    
    /// Skips part of, or return to some point on the loaded media.
    func seek(to time: TimeInterval) -> Bool {
        guard let player, canSeek, let totalRuntime else { return false }
        
        let withinBoundSecond = max(0, min(time, totalRuntime))
        let targetTime = CMTime(seconds: withinBoundSecond, preferredTimescale: Constants.CORE_MEDIA_TIMESCALE)
        
        self.isScrubbing = false
        player.seek(to: targetTime) { [weak self] _ in
            Task { @MainActor in 
                self?.currentTime = withinBoundSecond 
            }
        }
        
        return true
    }
    
    
    /// Suspends automatic runtime updates to prevent slider jitter.
    func beginTimeScrubbing() {
        self.isScrubbing = true
        Logger.playback.info("Started time scrubbing.")
    }
    
    
    /// Updates the current time displayed, without seeking the media.
    /// Used during active scrubbing.
    func updateTimeScrubbing(to time: Double) {
        guard isScrubbing, let totalRuntime else { return }
        self.currentTime = max(0, min(time, totalRuntime))
    }
    
    
    /// Ends time scrubbing and commit to the specified position.
    func endTimeScrubbing(at time: Double) {
        Logger.playback.info("Ended time scrubbing.")
        
        if self.seek(to: time) {
            Logger.playback.info("Seeked to \(time).")
        } else {
            Logger.playback.error("Failed to seek to \(time).")
        }
    }
    
}



/// Helper methods extension.
fileprivate extension MediaPlaybackService {
    
    
    /// Resets the service back to pristine condition.
    /// 
    /// Use this `reset` method to clear states between one media playback from the other.
    func reset() {
        if let player, let playbackTimeObserver { player.removeTimeObserver(playbackTimeObserver) }
        self.playbackTimeObserver = nil
        
        self.currentTime = 0
        self.totalRuntime = 0
        self.isScrubbing = false
        
        self.player?.pause()
        self.player = nil
        
        self.playabilityObserver?.invalidate()
        self.playabilityObserver = nil
        
        if let mediaFinishedPlayingObserver {
            NotificationCenter.default.removeObserver(mediaFinishedPlayingObserver)
            self.mediaFinishedPlayingObserver = nil
        }
        
        state = .idle
    }
    
    
    /// Determines whether media pointed in the URL can be played, 
    /// should it not have been resolved already.
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
                            Task { @MainActor in self.playabilityObserver?.invalidate() }
                            
                            switch item.status {
                            case .readyToPlay:
                                let duration = CMTimeGetSeconds(playerItem.duration)
                                Task { @MainActor in self.totalRuntime = duration }
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
            case .playing:
                Task { @MainActor in 
                    self.set(state: .playing(url)) 
                }
            case .waitingToPlayAtSpecifiedRate:
                Task { @MainActor in 
                    self.set(state: .buffering(url)) 
                }
            default:
                break
            }
        }
        
        self.mediaFinishedPlayingObserver = NotificationCenter.default.addObserver(
            forName: AVPlayerItem.didPlayToEndTimeNotification, 
            object: player.currentItem, 
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            
            Logger.playback.info("Media has finished playing.")
            Task { @MainActor in self.state = .finished(url) }
        }
        
        let updateInterval: CMTime = CMTime(seconds: 0.5, preferredTimescale: 10)
        self.playbackTimeObserver = player.addPeriodicTimeObserver(forInterval: updateInterval, queue: .main) { 
            [weak self] time in
            Task { @MainActor in 
                guard let self, !self.isScrubbing else { return }
                self.currentTime = CMTimeGetSeconds(time)
            }
        }
    }
    
    
    /// Enables outside mutation on `mediaStatusObserver`.
    func set(mediaStatusObserver: NSKeyValueObservation) {
        self.playabilityObserver = mediaStatusObserver
    }
    
    
    /// Enables outside mutation on `state`.
    func set(state: MediaPlaybackState) {
        self.state = state
    }
    
}
