//import XCTest
//import SwiftUI
//import ViewInspector
//@testable import Petfinder
//

// TODO: Keep an eye on ViewInspector and fix view.inspect().implicitAnyView().hStack()
//final class PetListCellTests: XCTestCase {
//
//    func testDisplaysPetNameAndBreedWhenLoaded() throws {
//        let favorites = Petfinder.Favorites()
//        let pet = Petfinder.Pet.random(name: "Buddy", breeds: Petfinder.Breeds(primary: "Labrador"), type: .dog)
//        favorites.add(pet)
//        let petListCellModel = Petfinder.PetListCellModel.from(pet, favorites: favorites)
//
//        let view = PetListCell(pet: petListCellModel, isLoading: false)
//
//        let hStack = try view.inspect().implicitAnyView().hStack()
//        let vStack = try hStack.vStack(1)
//
//        let nameText = try vStack.text(0).string()
//        XCTAssertEqual(nameText, "Buddy")
//
//        let breedText = try vStack.text(1).string()
//        XCTAssertEqual(breedText, "Labrador")
//    }
//
//    func testShowsShimmerWhenLoading() throws {
//        let view = PetListCell(pet: nil, isLoading: true)
//        let inspected = try view.inspect()
//
//        let hStack = try inspected.hStack()
//        XCTAssertNoThrow(hStack)
//    }
//
//    func testFavoriteButtonTriggersCallback() throws {
//        var toggleCalled = false
//        let pet = PetListCellModel(
//            id: 1,
//            name: "Buddy",
//            type: .dog,
//            primaryBreed: "Labrador",
//            secondaryBreed: nil,
//            photoURL: "",
//            isFavorite: true
//        )
//
//        let view = PetListCell(pet: pet, isLoading: false, onFavoriteToggle: { _ in
//            toggleCalled = true
//        }).environmentObject(Favorites())
//
//        let inspected = try view.inspect()
//        let button = try inspected.find(ViewType.Button.self)
//        try button.tap()
//
//        XCTAssertTrue(toggleCalled)
//    }
//}
