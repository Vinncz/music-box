import Foundation



struct iTunesCollectionResponse: Decodable {
    
    
    /// The name of the object returned by the search request.
    let wrapperType: iTunesWrapperType

    
    /// The kind of content returned by the search request.
    let collectionType: iTunesCollectionType
    
    
    /// Indicates when an item was published onto iTunes.
    let releaseDate: String
    
    
    
    // MARK: -- IDs
    
    /// The unique identifier for the artist associated with the entry.
    let artistId: Int
    
    
    /// The unique identifier for the album, TV season, audiobook, and so on associated with the entry.
    let collectionId: Int
    
    
    
    // MARK: -- Names
    
    /// The name of the artist returned by the search request.
    let artistName: String
    
    
    /// The name of the album, TV season, audiobook, and so on returned by the search request.
    let collectionName: String
    
    
    
    // MARK: -- Censored Names
    
    /// The name of the album, TV season, audiobook, and so on, with objectionable words *’d out.
    let collectionCensoredName: String
    
    
    
    // MARK: -- Artworks
    
    /// A URL for the artwork associated with the returned media type, sized to 60×60 pixels.
    let artworkUrl60: URL?
    
    
    /// A URL for the artwork associated with the returned media type, sized to 100×100 pixels.
    let artworkUrl100: URL?
    
    
    
    // MARK: -- iTunes URLs
    
    /// The URL to view the track's artist in the iTunes Store.
    let artistViewUrl: URL
    
    
    /// The URL to view the track's collection in the iTunes Store.
    let collectionViewUrl: URL
    
}



// swiftlint:disable line_length
extension iTunesCollectionResponse {
    
    
    /// Known and verified response. Useful when testing.
    static let beatlesAbbeyRoad = iTunesCollectionResponse(
        wrapperType: .collection, 
        collectionType: .album, 
        releaseDate: "1969-09-26T07:00:00Z", 
        artistId: 136975, 
        collectionId: 1441164426, 
        artistName: "The Beatles", 
        collectionName: "Abbey Road (Remastered)", 
        collectionCensoredName: "Abbey Road (Remastered)", 
        artworkUrl60: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music112/v4/df/db/61/dfdb615d-47f8-06e9-9533-b96daccc029f/18UMGIM31076.rgb.jpg/60x60bb.jpg")!,
        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music112/v4/df/db/61/dfdb615d-47f8-06e9-9533-b96daccc029f/18UMGIM31076.rgb.jpg/100x100bb.jpg")!,
        artistViewUrl: URL(string: "https://music.apple.com/us/artist/the-beatles/136975?uo=4")!,
        collectionViewUrl: URL(string: "https://music.apple.com/us/album/abbey-road-remastered/1441164426?uo=4")!
    )
    
}
// swiftlint:enable line_length
