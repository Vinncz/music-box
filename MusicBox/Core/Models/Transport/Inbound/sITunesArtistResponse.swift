import Foundation


/// Represents a creator. This is the top-level container in the iTunes hierarchy.
/// The API returns this for searches where the entity is `musicArtist` or similar.
struct iTunesArtistResponse: Decodable {
    
    
    /// The name of the object returned by the search request.
    let wrapperType: iTunesWrapperType

    
    /// The kind of content returned by the search request.
    let artistType: iTunesArtistType
    
    
    /// The unique identifier for the artist associated with the entry.
    let artistId: Int
    
    
    /// The name of the artist returned by the search request.
    let artistName: String
    
    
    /// URL to artist's website.
    let artistLinkUrl: URL
    
    
    /// Genre associated with this artist.
    let primaryGenreName: String
    
}



extension iTunesArtistResponse {
    
    
    static let theBeatles = iTunesArtistResponse(
        wrapperType: .artist, 
        artistType: .artist, 
        artistId: 136975, 
        artistName: "The Beatles", 
        artistLinkUrl: URL(string: "https://music.apple.com/us/artist/the-beatles/136975?uo=4")!, 
        primaryGenreName: "Rock"
    )
    
}
