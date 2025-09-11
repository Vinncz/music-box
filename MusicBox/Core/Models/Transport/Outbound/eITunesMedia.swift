import Foundation



/// Used to query entries from iTunes. It represents the high-level media type to be searched.
enum iTunesMedia: String, Encodable {
    
    
    case all
    
    
    case audiobook
    
    
    case ebook
    
    
    case movie
    
    
    case music
    
    
    case musicVideo
    
    
    case podcast
    
    
    case shortFilm
    
    
    case software
    
    
    case tvShow
    
}
