import Foundation



/// iTunes' entry hierarchy.
enum iTunesWrapperType: String, Decodable {
    
    
    /// iTunes' highest-order container.
    /// 
    /// An artist is the creator or primary contributor of an entry in iTunes.
    /// For music, it's the band or singer; for audiobook, it's the author;
    /// for podcast, it's the publisher or host. 
    /// 
    /// An artist may have numerous collections.
    case artist
    
    
    /// iTunes' middle-order container.
    /// 
    /// It is a grouping of tracks.
    /// For music, a collection is an album; for audiobooks, it's the book itself;
    /// for podcasts, it's the podcast series or show.
    /// 
    /// A collection always have at least one track.
    case collection
    
    
    /// iTunes' most granular container, representing a single piece of consumable media.
    ///
    /// A track is the individual item a user consumes, such as a song, a podcast
    /// episode, or a music video. 
    /// 
    /// A `track` is ALMOST always part of a `collection`.
    case track
    
    
    /// A special-case wrapper for audiobooks.
    /// 
    /// No mention were made in the official docs, but in practice,
    /// audiobooks are returned with this `wrapperType` instead of `collection`.
    case audiobook
    
}
