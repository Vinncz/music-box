import Foundation
import OSLog
import SwiftData



// TODO: -- SwiftData containers, contexts, anything should be declared inside.
/// Facades the underlying metadata-caching mechanism with SwiftData.
final class MetadataCacheSwiftDataService: MetadataCacheServicing {
    
    
    private var modelContext: ModelContext
    
    
    /// Initializes the service to work
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    
    /// Fetches metadata stored from the last active session.
    func retrieve() async throws -> [iTunesSong] {
//        let predicate = #Predicate<iTunesSong> { _ in true }
//        let descriptor = FetchDescriptor<iTunesSong>(predicate: predicate)
//        
//        return try modelContext.fetch(descriptor)
        return []
    }
    
    
    /// Stores the metadata from the current session for better app-launch experience.
    func store(_ metadata: [iTunesSong], replacingExisting: Bool) async throws {
//        if replacingExisting { try modelContext.delete(model: iTunesSong.self) }
//        metadata.forEach { modelContext.insert($0) }
    }
    
}
