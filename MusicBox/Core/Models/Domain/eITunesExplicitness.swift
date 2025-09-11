import Foundation



/// Content advisory rating of a ``iTunesWrapperType/collection`` or ``iTunesWrapperType/track``.
enum iTunesExplicitness: String, Codable {
    
    
    /// Contains explicit material (e.g., strong language, mature themes).
    case explicit
    
    
    /// Does not contain explicit material.
    case notExplicit
    
    
    /// Content was modified from the explicit original.
    case cleaned
    
}
