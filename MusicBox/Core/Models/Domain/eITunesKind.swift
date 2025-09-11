import Foundation



/// Represents the nature of an ``iTunesTrack``.
enum iTunesKind: String, Decodable {
    
    
    case album
    
    
    case artist
    
    
    case book
    
    
    case coachedAudio = "coached-audio"
    
    
    case featureMovie = "feature-movie"
    
    
    case interactiveBooklet = "interactive-booklet"
    
    
    case musicVideo = "music-video"
    
    
    case pdf
    
    
    case podcast
    
    
    case podcastEpisode = "podcast-episode"
    
    
    case softwarePackage = "software-package"
    
    
    case song
    
    
    case tvEpisode = "tv-episode"
    
}
