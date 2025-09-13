import Foundation
import Testing
@testable import MusicBox



struct iTunesResponseTests {
    
    
    @Test("Responses are successfully parsed") 
    func testAbleToParseReponses() async throws {
        let query = iTunesSearchQuery(term: "beatles", media: .all, limit: 200)
        let (data, _) = try await URLSession.shared.data(from: query.finalizedURL())
        
        let response = try JSONDecoder().decode(iTunesResponse.self, from: data)
        #expect(response.resultCount == response.results.count)
    }
    
    
    @Test("Missing required params result in no data being returned") 
    func testMissingRequiredParamsResultInNoDataBeingReturned() async throws {
        let query = iTunesSearchQuery(term: .EMPTY)
        let (data, _) = try await URLSession.shared.data(from: query.finalizedURL())
        
        let response = try JSONDecoder().decode(iTunesResponse.self, from: data)
        #expect(response.resultCount == 0)
    }
    
    
    @Test("Parsed response's results are correctly parsed into iTunesArtistResponse type")
    func testParseResponseIntoArtistResponse() async throws {
        let query = iTunesLookupQuery(ids: [136975])
        let (data, _) = try await URLSession.shared.data(from: query.finalizedURL())
        
        let response = try JSONDecoder().decode(iTunesResponse.self, from: data)
        let result = try #require(response.results.first)
        
        let mockedResult: iTunesResultResponse = .artist(.theBeatles)
        #expect(result == mockedResult)
    }
    
    
    @Test("Parsed response's results are correctly parsed into iTunesCollectionResponse type")
    func testParseResponseIntoCollectionResponse() async throws {
        let query = iTunesLookupQuery(ids: [1441164426])
        let (data, _) = try await URLSession.shared.data(from: query.finalizedURL())
        
        let response = try JSONDecoder().decode(iTunesResponse.self, from: data)
        let result = try #require(response.results.first)
        
        let mockedResult: iTunesResultResponse = .collection(.beatlesAbbeyRoad)
        #expect(result == mockedResult)
    }
    
    
    @Test("Parsed response's results are correctly parsed into iTunesTrackResponse type")
    func testParseResponseIntoTrackResponse() async throws {
        let query = iTunesLookupQuery(ids: [1441164427])
        let (data, _) = try await URLSession.shared.data(from: query.finalizedURL())
        
        let response = try JSONDecoder().decode(iTunesResponse.self, from: data)
        let result = try #require(response.results.first)
        
        let mockedResult: iTunesResultResponse = .track(.beatlesThingsWeSaidToday)
        #expect(result == mockedResult)
    }
    
}
