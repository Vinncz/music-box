import Foundation



/// Domain representation of an iTunes search query.
struct iTunesSearchQuery: Encodable {
    
    
    /// The URL-encoded text string to search for. For example: jack+johnson.
    var term: String
    
    
    /// The two-letter country code for the store to search in.
    var country: String = Constants.REGION
    
    
    /// The media type to search for.
    var media: iTunesMedia = .music
    
    
    /// The type of results to be returned, relative to the specified media type. 
    var entity: iTunesEntity = .song
    
    
    /// The number of search results to return. iTunes defaults to 50 if unspecified, up to 200.
    var limit: Int = 50
    
    
    /// A flag indicating whether or not to include explicit content in the search results. Defaults to `Yes`.
    var explicit: Bool = true
    
    
    /// Churns every attributes present into a URL for the iTunes Search API.
    func finalizedURL() -> URL {
        var components = URLComponents()
            components.scheme = "https"
            components.host = "itunes.apple.com"
            components.path = "/search"
            components.queryItems = [
                URLQueryItem(name: "term", value: term.sanitizedForURL),
                URLQueryItem(name: "country", value: country),
                URLQueryItem(name: "media", value: media.rawValue),
                URLQueryItem(name: "entity", value: entity.rawValue),
                URLQueryItem(name: "limit", value: String(limit)),
                URLQueryItem(name: "explicit", value: explicit.verbose)
            ]
        
        return components.url!
    }
    
}
