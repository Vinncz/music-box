import Foundation
import Testing
@testable import MusicBox



struct iTunesLookupQueryTests {
    
    
    @Test("System parses the URL as determined here") 
    func testAbleToFormCoherentURL() async throws {
        let ids = [1441164426, 1441164427, 1441164428]
        let idsString = ids.map { String($0) }
        let entity: iTunesEntity? = nil
        let limit: Int = 2
        
        
        let query = iTunesLookupQuery(ids: ids, 
                                      entity: entity, 
                                      limit: limit)
        let finalizedURL = query.finalizedURL()
        
        
        var comparator = URLComponents()
            comparator.scheme = "https"
            comparator.host   = "itunes.apple.com"
            comparator.path   = "/lookup"
            comparator.queryItems = [
                URLQueryItem(name: "id",     value: idsString.joined(separator: ",")),
                URLQueryItem(name: "limit",    value: String(limit))
            ]
        
        #expect(finalizedURL == comparator.url!)
        #expect(finalizedURL == URL(string: "https://itunes.apple.com/lookup?id=\(idsString.joined(separator: ","))&limit=\(limit)")!)
    }
    
}
