import Foundation
import Testing
@testable import MusicBox


struct iTunesSongTest {
    
    
    @Test("Convenient attributes")
    func testConvenientAttributes() {
        let song: iTunesSong = .beatlesYellowSubmarine
        #expect(song.artworkUrl == song.artworkUrl100)
        #expect(song.formattedReleaseDate == "5 Aug 1966") // Tested on SI locale
        #expect(song.formattedRuntime == "2:38")
        if case .explicit = song.explicitness {
            #expect(song.displayName == song.censoredTitle)
        } else {
            #expect(song.displayName == song.title)
        }
    }
    
    
    @Test("Initializable from mock iTunesTrackResponse")
    func testInitializableFromMockiTunesTrackResponse() throws {
        let response = iTunesTrackResponse.beatlesYellowSubmarine
        let song = try #require(iTunesSong(from: response))
        
        // Test them ids since SwiftData's @Model macro introduced `persistentModelID`
        #expect(song.id == iTunesSong.beatlesYellowSubmarine.id)
    }
    
    
    @Test("Initializable from actual iTunesTrackResponse")
    func testInitializableFromActualiTunesTrackResponse() async throws {
        let query = iTunesLookupQuery(ids: [1440833902])
        let (data, _) = try await URLSession.shared.data(from: query.finalizedURL())
        
        let response = try JSONDecoder().decode(iTunesResponse.self, from: data)
        let result = try #require(response.results.first)
        
        switch result {
            case let .track(track):
                let song = try #require(iTunesSong(from: track))
                #expect(song.id == iTunesSong.beatlesYellowSubmarine.id)
            default:
                fatalError("ID on lookup query did not point to Beatle's Yellow Submarine track.")
        }
    }
    
    
    @Test("Will not initialize where 'kind' is not 'song'")
    func testWillNotInitializeWhereKindIsNotSong() throws {
        let response: iTunesTrackResponse = .peterFlinthBeatlesFeatureMovie
        #expect(iTunesSong(from: response) == nil)
    }
    
    
    @Test("Will not initialize where 'previewUrl' is missing")
    func testWillNotInitializeWherePreviewUrlIsMissing() throws {
        let response: iTunesTrackResponse = .noPreviewResponse
        #expect(iTunesSong(from: response) == nil)
    }
    
}
