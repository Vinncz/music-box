import Foundation



extension String {
    
    
    /// An empty string constant.
    static let EMPTY = ""
    
    
    /// Returns a new string that is escaped, followed by percent-encoded for URL query usage.
    /// 
    /// - Important:
    /// Never sanitize an already percent-encoded strings.
    var sanitizedForURL: String {
        var allowed = CharacterSet.urlQueryAllowed
            allowed.remove(charactersIn: "?&/=")
        
        return replacing(" ", with: "+")
    }
    
}
