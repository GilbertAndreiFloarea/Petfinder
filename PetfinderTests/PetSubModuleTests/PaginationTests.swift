import XCTest
@testable import Petfinder

final class PaginationTests: XCTestCase {

    func testDecodeFullPagination() throws {
        let json = """
        {
            "current_page": 2,
            "count_per_page": 20,
            "total_pages": 5,
            "total_count": 100,
            "_links": {
                "next": {
                    "href": "/v2/animals?page=3"
                }
            }
        }
        """.data(using: .utf8)!

        let pagination = try JSONDecoder().decode(Pagination.self, from: json)

        XCTAssertEqual(pagination.currentPage, 2)
        XCTAssertEqual(pagination.countPerPage, 20)
        XCTAssertEqual(pagination.totalPages, 5)
        XCTAssertEqual(pagination.totalCount, 100)
        XCTAssertEqual(pagination.links.next?.href, "/v2/animals?page=3")
    }

    func testDecodeWithoutNextLink() throws {
        let json = """
        {
            "current_page": 1,
            "count_per_page": 20,
            "total_pages": 1,
            "total_count": 20,
            "_links": {
                "next": null
            }
        }
        """.data(using: .utf8)!

        let pagination = try JSONDecoder().decode(Pagination.self, from: json)

        XCTAssertEqual(pagination.currentPage, 1)
        XCTAssertNil(pagination.links.next)
    }

    func testDecodeWithMissingLinks() throws {
        let json = """
        {
            "current_page": 1,
            "count_per_page": 20,
            "total_pages": 1,
            "total_count": 20,
            "_links": {}
        }
        """.data(using: .utf8)!

        let pagination = try JSONDecoder().decode(Pagination.self, from: json)

        XCTAssertNil(pagination.links.next)
    }

    func testDecodeWithWrongTypes() {
        let json = """
        {
            "current_page": "two",
            "count_per_page": "twenty",
            "total_pages": "five",
            "total_count": "hundred",
            "_links": {
                "next": {
                    "href": "/v2/animals?page=3"
                }
            }
        }
        """.data(using: .utf8)!

        XCTAssertThrowsError(try JSONDecoder().decode(Pagination.self, from: json))
    }
}
