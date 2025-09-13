import Foundation
import Testing
@testable import MusicBox



struct iTunesSearchQueryTests {
    
    
    @Test("System parses the URL as determined here") 
    func testAbleToFormCoherentURL() async throws {
        let term = "beatles"
        let country = "US"
        let media: iTunesMedia = .music
        let entity: iTunesEntity = .song
        let limit: Int = 50
        let explicit: Bool = true
        
        
        let query = iTunesSearchQuery(term: term, 
                                      country: country, 
                                      media: media, 
                                      entity: entity, 
                                      limit: limit, 
                                      explicit: true)
        let finalizedURL = query.finalizedURL()
        
        
        var comparator = URLComponents()
            comparator.scheme = "https"
            comparator.host   = "itunes.apple.com"
            comparator.path   = "/search"
            comparator.queryItems = [
                URLQueryItem(name: "term",     value: term),
                URLQueryItem(name: "country",  value: country),
                URLQueryItem(name: "media",    value: media.rawValue),
                URLQueryItem(name: "entity",   value: entity.rawValue),
                URLQueryItem(name: "limit",    value: String(limit)),
                URLQueryItem(name: "explicit", value: explicit.verbose.description)
            ]
        
        #expect(finalizedURL == comparator.url!)
        #expect(finalizedURL == URL(string: "https://itunes.apple.com/search?term=\(term)&country=\(country)&media=\(media.rawValue)&entity=\(entity.rawValue)&limit=\(limit)&explicit=\(explicit.verbose)")!)
    }
    
    
    @Test("Arguments default to what are shown here") 
    func testExpectedDefaults() async throws {
        let term = "beatles"
        let country = Constants.REGION
        let media: iTunesMedia = .music
        let entity: iTunesEntity = .song
        let limit: Int = 50
        let explicit: Bool = true
        
        let query = iTunesSearchQuery(term: term)
        let finalizedURL = query.finalizedURL()
        
        var comparator = URLComponents()
            comparator.scheme = "https"
            comparator.host   = "itunes.apple.com"
            comparator.path   = "/search"
            comparator.queryItems = [
                URLQueryItem(name: "term",     value: term),
                URLQueryItem(name: "country",  value: country),
                URLQueryItem(name: "media",    value: media.rawValue),
                URLQueryItem(name: "entity",   value: entity.rawValue),
                URLQueryItem(name: "limit",    value: String(limit)),
                URLQueryItem(name: "explicit", value: explicit.verbose.description)
            ]
        
        #expect(finalizedURL == comparator.url!)
    }
    
}
