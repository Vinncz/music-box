import Foundation



extension Bool {
    
    
    /// Converts `true` to "Yes" and `false` to "No".
    var verbose: String {
        return if self { "Yes" } else { "No" }
    }
    
}
