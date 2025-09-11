import Foundation
import OSLog



extension Logger {
    
    
    /// The subsystem for the app's logging, using the bundle identifier or a default value.
    private static var subsystem: String { Bundle.main.bundleIdentifier ?? "com.vinapp.musicbox" }
    
    
    /// Logs the view cycles like a view that appeared.
    static let viewCycle = Logger(subsystem: subsystem, category: "viewcycle")
    
    
    /// Logs network related activities.
    static let network = Logger(subsystem: subsystem, category: "network")
    
    
    /// Logs the execution of tests.
    static let tests = Logger(subsystem: subsystem, category: "tests")
    
}
