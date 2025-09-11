import Foundation



struct iTunesTrackResponse: Decodable {
    
    
    /// The name of the object returned by the search request.
    let wrapperType: iTunesWrapperType

    
    /// The kind of content returned by the search request.
    let kind: iTunesKind
    
    
    /// Indicates when an item was published onto iTunes.
    let releaseDate: String
    
    
    /// Whether this track is streamable.
    let isStreamable: Bool
    
    
    
    // MARK: -- Names
    
    /// The name of the artist returned by the search request.
    let artistName: String
    
    
    /// The name of the album, TV season, audiobook, and so on returned by the search request.
    let collectionName: String?
    
    
    /// The name of the track, song, video, TV episode, and so on returned by the search request.
    let trackName: String
    
    
    
    // MARK: -- IDs
    
    /// The unique identifier for the artist associated with the entry.
    let artistId: Int
    
    
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
    let artistViewUrl: URL
    
    
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
        artworkUrl60: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music124/v4/db/a2/7a/dba27a46-3685-508d-d32e-a0e73cc82251/00602567713296.rgb.jpg/60x60bb.jpg")!, 
        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music124/v4/db/a2/7a/dba27a46-3685-508d-d32e-a0e73cc82251/00602567713296.rgb.jpg/100x100bb.jpg")!, 
        artistViewUrl: URL(string: "https://music.apple.com/us/artist/the-beatles/136975?uo=4")!, 
        collectionViewUrl: URL(string: "https://music.apple.com/us/album/things-we-said-today/1441164416?i=1441164427&uo=4")!, 
        trackViewUrl: URL(string: "https://music.apple.com/us/album/things-we-said-today/1441164416?i=1441164427&uo=4")!, 
        previewUrl: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/44/b0/92/44b0929c-9465-f69f-eebe-5397d1368abb/mzaf_11110694315384027444.plus.aac.p.m4a")!, 
        trackTimeMillis: 155333
    )
    
}
// swiftlint:enable line_length
