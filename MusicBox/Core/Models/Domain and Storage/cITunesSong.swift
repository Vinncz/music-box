import Foundation
import SwiftData



/// Represents a playable song from iTunes.
@Model class iTunesSong: Identifiable, Equatable {
    
    
    /// iTunes' identifier for this song.
    var id: Int
    
    
    /// The name, title, or callsign of this song.
    var title: String
    
    
    /// When this song was released (not just registered with iTunes).
    var releaseDate: Date
    
    
    /// Whether this track is streamable.
    var isStreamable: Bool
    
    
    
    // MARK: -- Explicitness
    
    /// Whether this track contains explicit content.
    var explicitness: iTunesExplicitness
    
    
    /// ``title`` with objectionable words *'d out.
    var censoredTitle: String
    
    
    
    // MARK: -- Artworks
    
    /// URL for the artwork, sized to 60×60 pixels.
    var artworkUrl60: URL?
    
    
    /// URL for the artwork, sized to 100×100 pixels.
    var artworkUrl100: URL?
    
    
    
    // MARK: -- iTunes URLs

    /// URL to view the track on iTunes.
    var trackViewUrl: URL
    
    
    
    // MARK: -- Preview Attributes
    
    /// URL to the 30-second preview file.
    var previewUrl: URL
    
    
    /// Original runtime of the full song in miliseconds.
    var runtime: Int
    
    
    
    // MARK: -- Init
    
    /// Initializes a new iTunes song. 
    /// 
    /// Use the accesible ``init(from:)`` instead to convert data-layer object into domain ones.
    private init(id: Int, title: String, releaseDate: Date, 
                 isStreamable: Bool, explicitness: iTunesExplicitness, 
                 censoredTitle: String, artworkUrl60: URL? = nil, 
                 artworkUrl100: URL? = nil, trackViewUrl: URL, 
                 previewUrl: URL, runtime: Int) {
        self.id = id
        self.title = title
        self.releaseDate = releaseDate
        self.isStreamable = isStreamable
        self.explicitness = explicitness
        self.censoredTitle = censoredTitle
        self.artworkUrl60 = artworkUrl60
        self.artworkUrl100 = artworkUrl100
        self.trackViewUrl = trackViewUrl
        self.previewUrl = previewUrl
        self.runtime = runtime
    }
    
}



/// Convenience attribute extension.
extension iTunesSong {
    
    
    /// Prefer the 100x100 artwork, but fall back to 60x60 if needed.
    var artworkUrl: URL? {
        artworkUrl100 ?? artworkUrl60
    }
    
    
    /// Returns the appropriate display name based on the song's explicitness.
    var displayName: String {
        return explicitness == .explicit ? censoredTitle : title
    }
    
    
    /// Returns a formatted string of the release date.
    var formattedReleaseDate: String {
        let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
        return formatter.string(from: releaseDate)
    }
    
    
    /// The runtime formatted as minutes and seconds (e.g., "3:45").
    var formattedRuntime: String {
        let totalSeconds = runtime / 1000
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
}



/// Init extension from transport layer.
extension iTunesSong {
    
    
    convenience init?(from dto: iTunesTrackResponse) {
        guard dto.wrapperType == .track
           && dto.kind == .song
        else { return nil }
        
        guard let dtoReleaseDate = try? Date(dto.releaseDate, strategy: .iso8601),
              let dtoIsStreamable = dto.isStreamable,
              let dtoPreviewUrl = dto.previewUrl,
              let dtoTrackTimeMillis = dto.trackTimeMillis
        else { return nil }
        
        self.init(
            id: dto.trackId,
            title: dto.trackName,
            releaseDate: dtoReleaseDate,
            isStreamable: dtoIsStreamable,
            explicitness: dto.trackExplicitness,
            censoredTitle: dto.trackCensoredName,
            artworkUrl60: dto.artworkUrl60,
            artworkUrl100: dto.artworkUrl100,
            trackViewUrl: dto.trackViewUrl,
            previewUrl: dtoPreviewUrl,
            runtime: dtoTrackTimeMillis,
        )
    }
    
}



// swiftlint:disable line_length force_try
extension iTunesSong {
    
    
    /// Verified information from the iTunes store.
    nonisolated(unsafe) static let beatlesYellowSubmarine = iTunesSong(
        id: 1440833902, 
        title: "Yellow Submarine", 
        releaseDate: try! Date("1966-08-05T12:00:00Z", strategy: .iso8601), 
        isStreamable: true, 
        explicitness: .notExplicit, 
        censoredTitle: "Yellow Submarine", 
        artworkUrl60: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music116/v4/f2/98/fb/f298fb48-1e0e-6ad4-4cff-fb824b77f02e/15UMGIM59587.rgb.jpg/60x60bb.jpg"), 
        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music116/v4/f2/98/fb/f298fb48-1e0e-6ad4-4cff-fb824b77f02e/15UMGIM59587.rgb.jpg/100x100bb.jpg"), 
        trackViewUrl: URL(string: "https://music.apple.com/us/album/yellow-submarine/1440833098?i=1440833902&uo=4")!, 
        previewUrl: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview211/v4/d8/4f/3c/d84f3cdc-d6af-5e06-72d1-6977e9d75e33/mzaf_7550261175979640242.plus.aac.p.m4a")!, 
        runtime: 158800
    )
    
}
// swiftlint:enable line_length force_try
