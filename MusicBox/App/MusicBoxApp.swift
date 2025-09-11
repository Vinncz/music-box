import SwiftUI
import SwiftData



@main
struct MusicBoxApp: App {
    
    
    @Environment(\.scenePhase) private var scenePhase
    
    
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Item.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: ")
//        }
//    }()
    
    
    var body: some Scene {
        WindowGroup {
            EmptyView()
        }
        // .onChange(of: scenePhase) { oldPhase, newPhase in
        //     switch newPhase {
        //     case .active:
        //         print("\(Bundle.main.displayName) is active")
        //     case .inactive:
        //         print("\(Bundle.main.displayName) is inactive")
        //     case .background:
        //         print("\(Bundle.main.displayName) is in the background")
        //     @unknown default:
        //         print("\(Bundle.main.displayName) has entered an unknown state")
        //     }
        // }
//        .modelContainer(sharedModelContainer)
    }
}
