import Foundation
import OSLog



/// Facades the use of iTunes API, its response, and processing them for domain use.
final class CatalogService: CatalogServicing {
    
    
    /// Performs a lookup with the given ids using ``iTunesLookupQuery``.
    func lookup(by ids: [Int], entity: iTunesEntity?, limit: Int?) async throws -> [iTunesSong] {
        let query = iTunesLookupQuery(ids: ids, entity: entity, limit: limit)
        return try await fetchAndProcessSongs(from: query.finalizedURL())
    }
    
    
    /// Performs a search operation with the given term using ``iTunesSearchQuery``.
    func search(term: String, country: String, media: iTunesMedia, 
                entity: iTunesEntity, limit: Int, explicit: Bool) async throws -> [iTunesSong] {
        let query = iTunesSearchQuery(term: term, country: country, media: media, 
                                      entity: entity, limit: limit, explicit: explicit)
        return try await fetchAndProcessSongs(from: query.finalizedURL())
    }
    
}



/// Helper method extension.
fileprivate extension CatalogService {
    
    
    /// Encapsulates the common logic of fetching data,
    /// decoding the response, and transforming it into ``iTunesSong``.
    func fetchAndProcessSongs(from url: URL) async throws -> [iTunesSong] {
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(iTunesResponse.self, from: data)
        
        return response.results.compactMap { (result) -> iTunesSong? in
            guard case let .track(trackResponse) = result else {
                return nil
            }
            
            return iTunesSong(from: trackResponse)
        }
    }
    
}
