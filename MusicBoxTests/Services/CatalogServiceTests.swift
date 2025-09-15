import Foundation
import Testing
import OSLog
@testable import MusicBox



struct CatalogServiceTests {
    
    
    @Test("Catalog service is able to search for terms")
    func testSearch() async throws {
        let catalogService: CatalogServicing = CatalogService()
        let songs = try await catalogService.search(term: "beatles", country: Constants.REGION, media: .music, entity: .song, limit: 50, explicit: true)
        
        #expect(songs.count > 0)
        
        let gibberish = try await catalogService.search(term: "xxXxxXxxXxxXxxXxxXxxXxxXxxXxxXxxXxx", country: Constants.REGION, media: .music, entity: .song, limit: 50, explicit: true)
        #expect(gibberish.count < 1)
    }
    
    
    @Test("Catalog service is able to perform lookups")
    func testLookup() async throws {
        let catalogService: CatalogServicing = CatalogService()
        let songs = try await catalogService.lookup(by: [1440833902], entity: nil, limit: 1)
        
        #expect(songs.count == 1)
        let song = try #require(songs.first)
        
        #expect(song.artistName == "The Beatles")
        #expect(song.id == 1440833902)
    }
    
}
