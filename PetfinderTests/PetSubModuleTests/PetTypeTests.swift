import XCTest
@testable import Petfinder

final class PetTypeTests: XCTestCase {

    func testDecodeKnownType() throws {
        let json = "\"Cat\"".data(using: .utf8)!
        let type = try JSONDecoder().decode(PetType.self, from: json)
        XCTAssertEqual(type, .cat)
    }

    func testDecodeUnknownType() throws {
        let json = "\"Lizard\"".data(using: .utf8)!
        let type = try JSONDecoder().decode(PetType.self, from: json)
        XCTAssertEqual(type, .unknown)
    }

    func testDecodeInvalidTypeThrows() {
        let json = "123".data(using: .utf8)!
        XCTAssertThrowsError(try JSONDecoder().decode(PetType.self, from: json))
    }
}
