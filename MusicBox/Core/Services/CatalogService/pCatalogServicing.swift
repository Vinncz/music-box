import Foundation



/// Interface that controls the facade to the iTunes API.
protocol CatalogServicing {
    
    
    /// Performs a lookup with the given ids using ``iTunesLookupQuery``.
    func lookup(by ids: [Int], entity: iTunesEntity?, limit: Int?) async throws -> [iTunesSong]
    
    
    /// Performs a search operation with the given term using ``iTunesSearchQuery``.
    func search(term: String, country: String, media: iTunesMedia, 
                entity: iTunesEntity, limit: Int, explicit: Bool) async throws -> [iTunesSong]
    
}
