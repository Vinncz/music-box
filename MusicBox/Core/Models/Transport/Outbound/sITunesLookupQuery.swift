import Foundation



/// Domain representation of an iTunes lookup query.
struct iTunesLookupQuery: Encodable {
    
    
    /// The unique identifier(s) for the item(s) to look up. 
    /// Multiple IDs can be specified, separated by no-space commas.
    var ids: [Int]
    
    
    /// The type of results to be returned, relative to the specified media type. 
    var entity: iTunesEntity?
    
    
    /// The number of search results to return. iTunes defaults to 50 if unspecified, up to 200.
    var limit: Int?
    
    
    /// Percent-encodes every attributes present to form a valid iTunes lookup URL.
    func finalizedURL() -> URL {
        var components = URLComponents()
            components.scheme = "https"
            components.host   = "itunes.apple.com"
            components.path   = "/lookup"
            components.queryItems = [
                URLQueryItem(name: "id", value: ids.map({ String($0) }).joined(separator: ","))
            ]
        
        if let entity {
            components.queryItems?.append(URLQueryItem(name: "entity", value: entity.rawValue))
        }
        
        if let limit {
            components.queryItems?.append(URLQueryItem(name: "limit", value: String(limit)))
        }
        
        return components.url!
    }
    
}
