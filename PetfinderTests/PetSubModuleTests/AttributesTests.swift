import XCTest
@testable import Petfinder

final class AttributesTests: XCTestCase {

    func testDecodeFullAttributes() throws {
        let json = """
        {
            "shots_current": true,
            "special_needs": false,
            "declawed": true,
            "house_trained": true,
            "spayed_neutered": true
        }
        """.data(using: .utf8)!

        let attributes = try JSONDecoder().decode(Attributes.self, from: json)

        XCTAssertTrue(attributes.shotsCurrent)
        XCTAssertFalse(attributes.specialNeeds)
        XCTAssertEqual(attributes.declawed, true)
        XCTAssertTrue(attributes.houseTrained)
        XCTAssertTrue(attributes.spayedNeutered)
    }

    func testDecodeWithoutOptional() throws {
        let json = """
        {
            "shots_current": false,
            "special_needs": true,
            "house_trained": false,
            "spayed_neutered": false
        }
        """.data(using: .utf8)!

        let attributes = try JSONDecoder().decode(Attributes.self, from: json)

        XCTAssertFalse(attributes.shotsCurrent)
        XCTAssertTrue(attributes.specialNeeds)
        XCTAssertNil(attributes.declawed)
        XCTAssertFalse(attributes.houseTrained)
        XCTAssertFalse(attributes.spayedNeutered)
    }

    func testDecodeWithInvalidData() {
        let json = """
        {
            "shots_current": "yes",
            "special_needs": "no",
            "declawed": "maybe",
            "house_trained": true,
            "spayed_neutered": false
        }
        """.data(using: .utf8)!

        XCTAssertThrowsError(try JSONDecoder().decode(Attributes.self, from: json))
    }
}
