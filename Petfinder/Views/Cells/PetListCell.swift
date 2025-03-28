import SwiftUI

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

struct PetListCell: View {
    
    @EnvironmentObject var favorites: Favorites
    @State private var animateSymbol = false
    let pet: PetListCellModel?
    var isLoading: Bool = false
    var onFavoriteToggle: ((PetListCellModel) -> Void)?
    
    var body: some View {
        if isLoading {
            HStack {
                ShimmerBar(width: 60, height: 60, cornerRadius: 20)

                VStack(alignment: .leading, spacing: 5) {
                    ShimmerBar(width: 120, height: 20)
                    
                    ShimmerBar(width: 80, height: 15)
                }
                
                Spacer()
                
                ShimmerBar(width: 40, height: 40, cornerRadius: 10)
                    .padding(.leading)
            }
            .padding(.vertical, 8)
        } else {
            if let pet = pet {
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color.gray.opacity(0.7))
                        let imageUrlString = pet.photoURL
                        PetRemoteImage(urlString: imageUrlString, type: pet.type)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .cornerRadius(20)
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        Text(pet.name)
                            .font(.title2)
                            .fontWeight(.medium)
                            .lineLimit(1)
                        
                        if let breed = pet.primaryBreed ?? pet.secondaryBreed {
                            Text(breed)
                                .font(.body)
                                .fontWeight(.medium)
                                .lineLimit(1)
                                .foregroundColor(.secondary)
                        }
                        
                    }

                    Spacer()

                    FavoriteToggleButton(isFavorite: .constant(pet.isFavorite)) {
                        onFavoriteToggle?(pet)
                    }
                    .padding(.leading)
                }
            }
        }
    }
}
