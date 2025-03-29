import XCTest
@testable import Petfinder

final class ContactTests: XCTestCase {

    func testDecodeFullContact() throws {
        let json = """
        {
            "email": "adoptinquire@peninsulahumanesociety.org",
            "phone": "650-340-7022",
            "address": {
                "address1": "1450 Rollins Road",
                "address2": null,
                "city": "Burlingame",
                "state": "CA",
                "postcode": "94010",
                "country": "US"
            }
        }
        """.data(using: .utf8)!

        let contact = try JSONDecoder().decode(Contact.self, from: json)

        XCTAssertEqual(contact.email, "adoptinquire@peninsulahumanesociety.org")
        XCTAssertEqual(contact.phone, "650-340-7022")
        XCTAssertEqual(contact.address.city, "Burlingame")
    }

    func testDecodeMissingEmailAndPhone() throws {
        let json = """
        {
            "address": {
                "address1": "1450 Rollins Road",
                "city": "Burlingame",
                "state": "CA",
                "postcode": "94010",
                "country": "US"
            }
        }
        """.data(using: .utf8)!

        let contact = try JSONDecoder().decode(Contact.self, from: json)

        XCTAssertNil(contact.email)
        XCTAssertNil(contact.phone)
        XCTAssertEqual(contact.address.address1, "1450 Rollins Road")
    }

    func testDecodeWithInvalidPhoneType() {
        let json = """
        {
            "email": "info@example.com",
            "phone": 1234567890,
            "address": {
                "address1": "123 Main St",
                "city": "Townsville",
                "state": "CA",
                "postcode": "12345",
                "country": "US"
            }
        }
        """.data(using: .utf8)!

        XCTAssertThrowsError(try JSONDecoder().decode(Contact.self, from: json))
    }
}
