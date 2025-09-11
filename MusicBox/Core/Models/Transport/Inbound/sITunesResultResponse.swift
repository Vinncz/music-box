import Foundation



/// Type-erased enum to handle different iTunes media types in a single array.
enum iTunesResultResponse: Decodable {
    
    
    /// Represents an artist result from iTunes.
    case artist(iTunesArtistResponse)
    
    
    /// Represents a collection result from iTunes.
    case collection(iTunesCollectionResponse)
    
    
    /// Represents a track result from iTunes.
    case track(iTunesTrackResponse)
    
    
    /// Represents an unsupported result type.
    case unknown(wrapperType: String?, kind: String?)
    
    
    /// Custom decoder implementation.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let wrapperType = try container.decodeIfPresent(iTunesWrapperType.self, forKey: .wrapperType)
        let kind = try container.decodeIfPresent(iTunesKind.self, forKey: .kind)

        switch wrapperType {
        case .track:
            let track = try iTunesTrackResponse(from: decoder)
            self = .track(track)
        case .collection:
            let collection = try iTunesCollectionResponse(from: decoder)
            self = .collection(collection)
        case .artist:
            let artist = try iTunesArtistResponse(from: decoder)
            self = .artist(artist)
        default:
            self = .unknown(wrapperType: wrapperType?.rawValue, kind: kind?.rawValue)
        }
    }
    
    
    /// Explicitly-defined coding keys for custom decode impl.
    private enum CodingKeys: String, CodingKey {
        case wrapperType, kind
    }
    
}



extension iTunesResultResponse: Equatable {
    
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.artist, .artist):
            return true
        case (.collection, .collection):
            return true
        case (.track, .track):
            return true
        case (.unknown, .unknown):
            return true
        default:
            return false
        }
    }
    
}
