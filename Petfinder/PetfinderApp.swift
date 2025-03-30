import SwiftUI
import SwiftData

@main
struct PetfinderApp: App {
    var favorites = Favorites()
    // TODO: Create lightweight Pet model in swift data
    // TODO: Store API_KEY and API_SECRET on server, or use remote config.
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Pet.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()

    var body: some Scene {
        WindowGroup {
            MainTabView().environmentObject(favorites)
        }
//        .modelContainer(sharedModelContainer)
    }
}
