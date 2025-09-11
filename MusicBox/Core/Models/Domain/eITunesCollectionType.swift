import Foundation



/// Specific category for the wrapper's ``iTunesWrapperType/collection`` case.
enum iTunesCollectionType: String, Decodable {
    
    
    /// A standard music album by a single artist or group.
    case album = "Album"
    
    
    /// An entire audiobook.
    /// - Warning: This value is rarely seen for `collectionType`. 
    ///   The API typically uses the `wrapperType` of ``iTunesWrapperType/audiobook`` instead. 
    ///   (Found this out the hard way while testing, while omitting entity and media).
    case audiobook = "Audiobook"
    
    
    /// A collection of works from various artists. Example include movie soundtracks 
    /// or a mix (e.g., "J-Pop Hits").
    case compilation = "Compilation"
    
    
    /// A podcast series or show. This object acts as the container for all episodes
    /// and contains metadata like the show's RSS feed URL (`feedUrl`).
    case podcast = "Podcast"
    
}
