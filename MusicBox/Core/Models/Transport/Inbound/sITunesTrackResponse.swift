import Foundation



struct iTunesTrackResponse: Decodable {
    
    
    /// The name of the object returned by the search request.
    let wrapperType: iTunesWrapperType

    
    /// The kind of content returned by the search request.
    let kind: iTunesKind
    
    
    /// Indicates when an entry was released (not just registered with iTunes).
    let releaseDate: String
    
    
    /// Whether this track is streamable.
    let isStreamable: Bool?
    
    
    
    // MARK: -- Names
    
    /// The name of the artist returned by the search request.
    let artistName: String
    
    
    /// The name of the album, TV season, audiobook, and so on returned by the search request.
    let collectionName: String?
    
    
    /// The name of the track, song, video, TV episode, and so on returned by the search request.
    let trackName: String
    
    
    
    // MARK: -- IDs
    
    /// The unique identifier for the artist associated with the entry.
    let artistId: Int?
    
    
    /// The unique identifier for the album, TV season, audiobook, and so on associated with the entry.
    let collectionId: Int?
    
    
    /// The unique identifier for the track, song, video, TV episode, and so on associated with the entry.
    let trackId: Int
    
    
    
    // MARK: -- Explicitness
    
    /// Whether the track contains explicit content.
    let trackExplicitness: iTunesExplicitness
    
    
    /// The name of the album, TV season, audiobook, and so on, with objectionable words *’d out.
    let collectionCensoredName: String?
    
    
    /// The name of the album, TV season, audiobook, and so on, with objectionable words *’d out.
    let trackCensoredName: String
    
    
    
    // MARK: -- Artworks
    
    /// A URL for the artwork associated with the returned media type, sized to 60×60 pixels.
    let artworkUrl60: URL?
    
    
    /// A URL for the artwork associated with the returned media type, sized to 100×100 pixels.
    let artworkUrl100: URL?
    
    
    
    // MARK: -- iTunes URLs
    
    /// The URL to view the track's artist in the iTunes Store.
    let artistViewUrl: URL?
    
    
    /// The URL to view the track's collection in the iTunes Store.
    let collectionViewUrl: URL?
    
    
    /// The URL to view the track in the iTunes Store.
    let trackViewUrl: URL
    
    
    
    // MARK: -- Preview Attributes
    
    /// A URL referencing the 30-second preview file for the content associated with the returned media type.
    let previewUrl: URL?
    
    
    /// The returned track’s time in milliseconds.
    let trackTimeMillis: Int?
    
}



// swiftlint:disable line_length
extension iTunesTrackResponse {
    
    
    /// Known and verified response. Useful when testing.
    static let beatlesThingsWeSaidToday = iTunesTrackResponse(
        wrapperType: .track, 
        kind: .song, 
        releaseDate: "1964-07-10T12:00:00Z", 
        isStreamable: true, 
        artistName: "The Beatles", 
        collectionName: "A Hard Day's Night", 
        trackName: "Things We Said Today", 
        artistId: 136975, 
        collectionId: 1441164416, 
        trackId: 1441164427, 
        trackExplicitness: .notExplicit, 
        collectionCensoredName: "A Hard Day's Night", 
        trackCensoredName: "Things We Said Today", 
        artworkUrl60: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music124/v4/db/a2/7a/dba27a46-3685-508d-d32e-a0e73cc82251/00602567713296.rgb.jpg/60x60bb.jpg"), 
        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music124/v4/db/a2/7a/dba27a46-3685-508d-d32e-a0e73cc82251/00602567713296.rgb.jpg/100x100bb.jpg"), 
        artistViewUrl: URL(string: "https://music.apple.com/us/artist/the-beatles/136975?uo=4"), 
        collectionViewUrl: URL(string: "https://music.apple.com/us/album/things-we-said-today/1441164416?i=1441164427&uo=4"), 
        trackViewUrl: URL(string: "https://music.apple.com/us/album/things-we-said-today/1441164416?i=1441164427&uo=4")!, 
        previewUrl: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/44/b0/92/44b0929c-9465-f69f-eebe-5397d1368abb/mzaf_11110694315384027444.plus.aac.p.m4a"), 
        trackTimeMillis: 155333
    )
    
    
    /// Known and verified response. Useful when testing.
    static let beatlesYellowSubmarine = iTunesTrackResponse(
        wrapperType: .track, 
        kind: .song, 
        releaseDate: "1966-08-05T12:00:00Z", 
        isStreamable: true, 
        artistName: "The Beatles", 
        collectionName: "1", 
        trackName: "Yellow Submarine", 
        artistId: 136975, 
        collectionId: 1440833098, 
        trackId: 1440833902, 
        trackExplicitness: .notExplicit, 
        collectionCensoredName: "1", 
        trackCensoredName: "Yellow Submarine", 
        artworkUrl60: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music116/v4/f2/98/fb/f298fb48-1e0e-6ad4-4cff-fb824b77f02e/15UMGIM59587.rgb.jpg/60x60bb.jpg"), 
        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music116/v4/f2/98/fb/f298fb48-1e0e-6ad4-4cff-fb824b77f02e/15UMGIM59587.rgb.jpg/100x100bb.jpg"), 
        artistViewUrl: URL(string: "https://music.apple.com/us/artist/the-beatles/136975?uo=4")!, 
        collectionViewUrl: URL(string: "https://music.apple.com/us/album/yellow-submarine/1440833098?i=1440833902&uo=4"), 
        trackViewUrl: URL(string: "https://music.apple.com/us/album/yellow-submarine/1440833098?i=1440833902&uo=4")!, 
        previewUrl: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview211/v4/d8/4f/3c/d84f3cdc-d6af-5e06-72d1-6977e9d75e33/mzaf_7550261175979640242.plus.aac.p.m4a"), 
        trackTimeMillis: 158800
    )
    
    
    /// Known and verified response. Useful when testing.
    static let peterFlinthBeatlesFeatureMovie = iTunesTrackResponse(
        wrapperType: .track, 
        kind: .featureMovie, 
        releaseDate: "2015-12-01T08:00:00Z", 
        isStreamable: true, 
        artistName: "Peter Flinth", 
        collectionName: "1", 
        trackName: "Beatles", 
        artistId: -1, 
        collectionId: -1, 
        trackId: 1044979208, 
        trackExplicitness: .notExplicit, 
        collectionCensoredName: "1", 
        trackCensoredName: "Beatles", 
        artworkUrl60: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Video3/v4/72/b7/4b/72b74ba0-ae39-9617-31aa-876f84495f8a/Beatles_ART_WW_iTunes.jpg/60x60bb.jpg"), 
        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Video3/v4/72/b7/4b/72b74ba0-ae39-9617-31aa-876f84495f8a/Beatles_ART_WW_iTunes.jpg/100x100bb.jpg"), 
        artistViewUrl: nil, 
        collectionViewUrl: nil, 
        trackViewUrl: URL(string: "https://itunes.apple.com/us/movie/beatles/id1044979208?uo=4")!, 
        previewUrl: URL(string: "https://video-ssl.itunes.apple.com/itunes-assets/Video118/v4/7d/ff/42/7dff4228-54dc-7325-339c-cc00962cf294/mzvf_4843619287539817147.640x380.h264lc.U.p.m4v"), 
        trackTimeMillis: 6779615
    )
    
    
    /// Made up response. Useful when testing.
    static let noPreviewResponse = iTunesTrackResponse(
        wrapperType: .track, 
        kind: .pdf, 
        releaseDate: "1990-01-01T00:00:00Z", 
        isStreamable: true, 
        artistName: "Nein", 
        collectionName: "Nos", 
        trackName: "No Preview", 
        artistId: -1, 
        collectionId: -1, 
        trackId: -1, 
        trackExplicitness: .notExplicit, 
        collectionCensoredName: "Nos", 
        trackCensoredName: "No Preview", 
        artworkUrl60: nil, 
        artworkUrl100: nil, 
        artistViewUrl: nil, 
        collectionViewUrl: nil, 
        trackViewUrl: URL(string: "https://itunes.apple.com/us/movie/beatles/id1044979208?uo=4")!, 
        previewUrl: nil, 
        trackTimeMillis: 6779615
    )
    
}
// swiftlint:enable line_length
