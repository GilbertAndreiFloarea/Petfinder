import XCTest
@testable import Petfinder

@MainActor
final class PetsListViewModelTests: XCTestCase {
    
    var sut: Petfinder.PetsListViewModel!
    var mockFavorites: Petfinder.Favorites!

    override func setUp() {
        super.setUp()
        mockFavorites = Petfinder.Favorites()
        sut = Petfinder.PetsListViewModel(favorites: mockFavorites)
    }

    override func tearDown() {
        sut = nil
        mockFavorites = nil
        super.tearDown()
    }

    func testInitialValues() async {
        await MainActor.run {
            XCTAssertTrue(sut.pets.isEmpty)
            XCTAssertNil(sut.alertItem)
            XCTAssertFalse(sut.isLoading)
            XCTAssertFalse(sut.isShowingDetail)
            XCTAssertNil(sut.selectedPet)
        }
    }

    func testToggleFavorite_addsAndRemovesPet() {
        let pet = Petfinder.Pet.random()
        sut.pets = [pet]
        let model = Petfinder.PetListCellModel.from(pet, favorites: mockFavorites)

        sut.toggleFavorite(for: model)
        XCTAssertTrue(mockFavorites.pets.contains(pet))

        sut.toggleFavorite(for: model)
        XCTAssertFalse(mockFavorites.pets.contains(pet))
    }

    func testFilterPets_removesDuplicates() async {
        await MainActor.run {
            let pet1 = Petfinder.Pet.random(id: 1)
            let pet2 = Petfinder.Pet.random(id: 1)

            let result = sut.filterPets(pets: [pet1, pet2])
            XCTAssertEqual(result.count, 1)
        }
    }
}
