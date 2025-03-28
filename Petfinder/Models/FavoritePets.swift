import SwiftUI

final class Favorites: ObservableObject {
    
    @Published var pets: [Pet] = []
    
    func add(_ favorite: Pet) {
        pets.append(favorite)
    }
    
    func deleteItems(at offsets: IndexSet) {
        pets.remove(atOffsets: offsets)
    }
    
    func delete(by id: Int) {
        if let index = pets.firstIndex(where: { $0.id == id }) {
            pets.remove(at: index)
        }
    }
}
