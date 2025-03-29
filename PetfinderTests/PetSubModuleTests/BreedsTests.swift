import XCTest
@testable import Petfinder

final class BreedsTests: XCTestCase {

    func testDecodeFullBreeds() throws {
        let json = """
        {
            "primary": "Domestic Short Hair",
            "secondary": null,
            "mixed": false,
            "unknown": false
        }
        """.data(using: .utf8)!

        let breeds = try JSONDecoder().decode(Breeds.self, from: json)

        XCTAssertEqual(breeds.primary, "Domestic Short Hair")
        XCTAssertNil(breeds.secondary)
        XCTAssertEqual(breeds.mixed, false)
        XCTAssertEqual(breeds.unknown, false)
    }

    func testDecodeEmptyBreeds() throws {
        let json = """
        {
        }
        """.data(using: .utf8)!

        let breeds = try JSONDecoder().decode(Breeds.self, from: json)

        XCTAssertNil(breeds.primary)
        XCTAssertNil(breeds.secondary)
        XCTAssertNil(breeds.mixed)
        XCTAssertNil(breeds.unknown)
    }

    func testDecodeWithWrongTypes() {
        let json = """
        {
            "primary": 123,
            "mixed": "no"
        }
        """.data(using: .utf8)!

        XCTAssertThrowsError(try JSONDecoder().decode(Breeds.self, from: json))
    }
}
