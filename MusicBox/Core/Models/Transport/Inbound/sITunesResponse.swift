import Foundation



/// Wrapper struct for the entire iTunes API response.
struct iTunesResponse: Decodable {
    
    
    /// The number of results returned by the iTunes API.
    let resultCount: Int
    
    
    /// The array of results returned by the iTunes API.
    let results: [iTunesResultResponse]
    
}
