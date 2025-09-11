import Foundation



/// Used to query entries from iTunes. It represents the type of results relative to the specified media type.
enum iTunesEntity: String, CaseIterable, Encodable {
    
    
    /// Usable where ``iTunesSearchQuery/media`` is ``iTunesMedia/movie``.
    case movieArtist, movie
    
    
    /// Usable where ``iTunesSearchQuery/media`` is ``iTunesMedia/podcast``.
    case podcastAuthor, podcast, podcastEpisode
    
    
    /// Usable where ``iTunesSearchQuery/media`` is ``iTunesMedia/music``.
    case album, musicVideo, mix, song
    
    
    /// Usable where ``iTunesSearchQuery/media`` is ``iTunesMedia/music`` or ``iTunesMedia/musicVideo``.
    case musicArtist, musicTrack
    
    
    /// Usable where ``iTunesSearchQuery/media`` is ``iTunesMedia/audiobook``.
    case audiobookAuthor, audiobook
    
    
    /// Usable where ``iTunesSearchQuery/media`` is ``iTunesMedia/shortFilm``.
    case shortFilmArtist, shortFilm
    
    
    /// Usable where ``iTunesSearchQuery/media`` is ``iTunesMedia/tvShow``.
    case tvEpisode, tvSeason
    
    
    /// Usable where ``iTunesSearchQuery/media`` is ``iTunesMedia/software``.
    case software, iPadSoftware, desktopSoftware
    
    
    /// Usable where ``iTunesSearchQuery/media`` is ``iTunesMedia/ebook``.
    case ebook
    
}



/// Convenience methods of `iTunesEntity`.
extension iTunesEntity {
    
    
    /// Filters applicable entities for the given media type.
    static func applicable(for media: iTunesMedia) -> [Self] {
        switch media {
        case .movie:
            [.movieArtist, .movie]
        case .podcast:
            [.podcastAuthor, .podcast, .podcastEpisode]
        case .music:
            [.musicArtist, .musicTrack, .album, .musicVideo, .mix, .song]
        case .musicVideo:
            [.musicArtist, .musicTrack]
        case .audiobook:
            [.audiobookAuthor, .audiobook]
        case .shortFilm:
            [.shortFilmArtist, .shortFilm]
        case .tvShow:
            [.tvEpisode, .tvSeason]
        case .software:
            [.software, .iPadSoftware, .desktopSoftware]
        case .ebook:
            [.ebook]
        case .all:
            Self.allCases
        }
    }
    
}
