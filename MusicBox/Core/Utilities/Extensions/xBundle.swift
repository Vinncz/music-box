import Foundation



extension Bundle {
    
    
    /// The app name displayed below the icon on desktop or home screen or app gallery.
    var displayName: String {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "Music Box"
    }
    
}
