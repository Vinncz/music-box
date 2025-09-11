import Foundation



/// Specific category for the wrapper's ``iTunesWrapperType/artist`` case.
enum iTunesArtistType: String, Decodable {
    
    
    /// A musician, band, or other primary musical contributor.
    case artist = "Artist"
    
    
    /// The author of an audiobook.
    case author = "Author"
    
    
    /// The creator, host, or publisher of a podcast.
    case podcastArtist = "Podcast Artist"
    
}
