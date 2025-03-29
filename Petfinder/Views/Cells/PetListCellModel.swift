struct PetListCellModel: Equatable, Identifiable {
    let id: Int
    let name: String
    let type: PetType
    let primaryBreed: String?
    let secondaryBreed: String?
    var photoURL: String
    let isFavorite: Bool

    static func from(_ pet: Pet, favorites: Favorites) -> PetListCellModel {
        return PetListCellModel(
            id: pet.id,
            name: pet.name,
            type: pet.type,
            primaryBreed: pet.breeds.primary,
            secondaryBreed: pet.breeds.secondary,
            photoURL: pet.primaryPhotoCropped?.small ?? pet.photos.first?.small ?? "",
            isFavorite: favorites.pets.contains(pet)
        )
    }
}
