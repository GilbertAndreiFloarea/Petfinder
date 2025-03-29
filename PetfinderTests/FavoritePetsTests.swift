import XCTest
@testable import Petfinder

final class FavoritesTests: XCTestCase {
    func testAddFavoritePet() {
        let favorites = Favorites()
        let pet = Pet.random(id: 1)
        favorites.add(pet)
        
        XCTAssertEqual(favorites.pets.count, 1)
        XCTAssertEqual(favorites.pets.first?.id, 1)
    }

    func testDeletePetByIndexSet() {
        let favorites = Favorites()
        favorites.pets = [Pet.random(id: 1), Pet.random(id: 2)]
        favorites.deleteItems(at: IndexSet(integer: 0))
        
        XCTAssertEqual(favorites.pets.count, 1)
        XCTAssertEqual(favorites.pets.first?.id, 2)
    }

    func testDeletePetByID() {
        let favorites = Favorites()
        favorites.pets = [Pet.random(id: 1), Pet.random(id: 2)]
        favorites.delete(by: 2)
        
        XCTAssertEqual(favorites.pets.count, 1)
        XCTAssertEqual(favorites.pets.first?.id, 1)
    }
}

