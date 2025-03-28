import SwiftUI

struct FavoritesView: View {
    
    @EnvironmentObject var favorites: Favorites
    @State private var selectedPet: Pet?
    @State private var isShowingDetail = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    List {
                        ForEach(favorites.pets) { pet in
                            Button {
                                selectedPet = pet
                                isShowingDetail = true
                            } label: {
                                let model = PetListCellModel.from(pet, favorites: favorites)

                                PetListCell(pet: model, onFavoriteToggle: { _ in favorites.delete(by: pet.id) })
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .onDelete(perform: favorites.deleteItems)
                    }
                    .listStyle(PlainListStyle())
                }
                
                if favorites.pets.isEmpty {
                    EmptyState(imageName: "pet_adoption_image",
                               message: "You have no favorite pets yet.\nPlease pick one!")
                }
            }
            .navigationTitle("🐶🐱 Furry Favorites")
        }
        .sheet(item: $selectedPet) { pet in
            PetDetailView(pet: pet, isShowingDetail: $isShowingDetail, useCustomFrame: false)
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
