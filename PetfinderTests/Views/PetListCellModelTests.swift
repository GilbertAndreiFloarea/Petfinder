import XCTest
@testable import Petfinder

final class PetListCellModelTests: XCTestCase {
    
    // TODO: create randomalphanumericstring helper for testing

    func testFrom_usesPrimaryPhotoCroppedIfAvailable() {
        let pet = Petfinder.Pet.random(
            id: 1,
            name: "Whiskers",
            breeds: Petfinder.Breeds(
                primary: "Tabby",
                secondary: nil,
                mixed: Bool.random(),
                unknown: Bool.random()
            ),
            primaryPhotoCropped: Petfinder.Photo(
                small: "small.jpg",
                medium: "medium.jpg",
                large: "large.jpg",
                full: "full.jpg"
            ),
            type: .cat
        )
        let favorites = Petfinder.Favorites()
        let model = PetListCellModel.from(pet, favorites: favorites)

        XCTAssertEqual(model.id, 1)
        XCTAssertEqual(model.name, "Whiskers")
        XCTAssertEqual(model.type, .cat)
        XCTAssertEqual(model.primaryBreed, "Tabby")
        XCTAssertNil(model.secondaryBreed)
        XCTAssertEqual(model.photoURL, "small.jpg")
        XCTAssertFalse(model.isFavorite)
    }

    func testFrom_usesFirstPhotoIfNoPrimaryPhoto() {
        let pet = Petfinder.Pet.random(
            id: 1,
            name: "Whiskers",
            breeds: Petfinder.Breeds(
                primary: "Tabby",
                secondary: nil,
                mixed: Bool.random(),
                unknown: Bool.random()
            ),
            primaryPhotoCropped: nil,
            photos: [Petfinder.Photo(
                small: "small.jpg",
                medium: "medium.jpg",
                large: "large.jpg",
                full: "full.jpg"
            )],
            type: .cat
        )

        let favorites = Petfinder.Favorites()
        let model = PetListCellModel.from(pet, favorites: favorites)

        XCTAssertEqual(model.photoURL, "small.jpg")
    }

    func testFrom_usesEmptyStringIfNoPhotos() {
        let pet = Petfinder.Pet.random(
            id: 1,
            name: "Whiskers",
            breeds: Petfinder.Breeds(
                primary: "Tabby",
                secondary: nil,
                mixed: Bool.random(),
                unknown: Bool.random()
            ),
            primaryPhotoCropped: nil,
            photos: [],
            type: .cat
        )
        let favorites = Petfinder.Favorites()
        let model = PetListCellModel.from(pet, favorites: favorites)

        XCTAssertEqual(model.photoURL, "")
    }

    func testFrom_setsIsFavoriteTrueIfInFavorites() {
        let pet = Petfinder.Pet.random(
            id: 1,
            name: "Whiskers",
            breeds: Petfinder.Breeds(
                primary: "Tabby",
                secondary: nil,
                mixed: Bool.random(),
                unknown: Bool.random()
            ),
            primaryPhotoCropped: Petfinder.Photo(
                small: "small.jpg",
                medium: "medium.jpg",
                large: "large.jpg",
                full: "full.jpg"
            ),
            type: .cat
        )
        let favorites = Petfinder.Favorites()
        favorites.add(pet)
        let model = PetListCellModel.from(pet, favorites: favorites)

        XCTAssertTrue(model.isFavorite)
    }
}
