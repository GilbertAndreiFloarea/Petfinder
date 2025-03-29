import XCTest
@testable import Petfinder

final class AddressTests: XCTestCase {

    func testDecodeFullAddress() throws {
        let json = """
        {
            "address1": "123 Pet St",
            "address2": "Suite B",
            "city": "Dogtown",
            "state": "CA",
            "postcode": "90210",
            "country": "USA"
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let address = try decoder.decode(Address.self, from: json)

        XCTAssertEqual(address.address1, "123 Pet St")
        XCTAssertEqual(address.address2, "Suite B")
        XCTAssertEqual(address.city, "Dogtown")
        XCTAssertEqual(address.state, "CA")
        XCTAssertEqual(address.postcode, "90210")
        XCTAssertEqual(address.country, "USA")
    }

    func testDecodePartialAddress() throws {
        let json = """
        {
            "city": "Catville",
            "country": "Canada"
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let address = try decoder.decode(Address.self, from: json)

        XCTAssertNil(address.address1)
        XCTAssertNil(address.address2)
        XCTAssertEqual(address.city, "Catville")
        XCTAssertNil(address.state)
        XCTAssertNil(address.postcode)
        XCTAssertEqual(address.country, "Canada")
    }
}
