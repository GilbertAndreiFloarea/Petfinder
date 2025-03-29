import XCTest
@testable import Petfinder

final class PhotoTests: XCTestCase {

    func testDecodeFullPhoto() throws {
        let json = """
        {
            "small": "https://example.com/small.jpg",
            "medium": "https://example.com/medium.jpg",
            "large": "https://example.com/large.jpg",
            "full": "https://example.com/full.jpg"
        }
        """.data(using: .utf8)!

        let photo = try JSONDecoder().decode(Photo.self, from: json)

        XCTAssertEqual(photo.small, "https://example.com/small.jpg")
        XCTAssertEqual(photo.medium, "https://example.com/medium.jpg")
        XCTAssertEqual(photo.large, "https://example.com/large.jpg")
        XCTAssertEqual(photo.full, "https://example.com/full.jpg")
    }

    func testDecodePartialPhoto() throws {
        let json = """
        {
            "small": "https://example.com/small.jpg"
        }
        """.data(using: .utf8)!

        let photo = try JSONDecoder().decode(Photo.self, from: json)

        XCTAssertEqual(photo.small, "https://example.com/small.jpg")
        XCTAssertNil(photo.medium)
        XCTAssertNil(photo.large)
        XCTAssertNil(photo.full)
    }

    func testDecodeWithWrongTypes() {
        let json = """
        {
            "small": 123,
            "medium": false,
            "large": ["image"],
            "full": null
        }
        """.data(using: .utf8)!

        XCTAssertThrowsError(try JSONDecoder().decode(Photo.self, from: json))
    }
}
