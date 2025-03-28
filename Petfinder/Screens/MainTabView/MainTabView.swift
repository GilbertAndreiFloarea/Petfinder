import SwiftUI

struct MainTabView: View {
    
    @EnvironmentObject var favorites: Favorites
    
    var body: some View {
        TabView {
            PetsListView(favorites: favorites)
                .tabItem { Label("Pets", systemImage: "house") }
            
            FavoritesView()
                .tabItem { Label("Favorite", systemImage: "star") }
                .badge(favorites.pets.count)
        }
        .tint(.petPrimary)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
