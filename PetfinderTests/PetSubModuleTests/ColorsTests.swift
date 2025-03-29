import XCTest
@testable import Petfinder

final class ColorsTests: XCTestCase {

    func testDecodeFullColors() throws {
        let json = """
        {
            "primary": "Black",
            "secondary": "White",
            "tertiary": "Gray"
        }
        """.data(using: .utf8)!

        let colors = try JSONDecoder().decode(Colors.self, from: json)

        XCTAssertEqual(colors.primary, "Black")
        XCTAssertEqual(colors.secondary, "White")
        XCTAssertEqual(colors.tertiary, "Gray")
    }

    func testDecodeEmptyColors() throws {
        let json = """
        {
        }
        """.data(using: .utf8)!

        let colors = try JSONDecoder().decode(Colors.self, from: json)

        XCTAssertNil(colors.primary)
        XCTAssertNil(colors.secondary)
        XCTAssertNil(colors.tertiary)
    }

    func testDecodeWithWrongTypes() {
        let json = """
        {
            "primary": 123,
            "secondary": true,
            "tertiary": ["blue"]
        }
        """.data(using: .utf8)!

        XCTAssertThrowsError(try JSONDecoder().decode(Colors.self, from: json))
    }
}
