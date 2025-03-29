/// A model representing a physical address associated with a pet or organization.
///
/// This struct conforms to `Codable` to allow easy decoding from or encoding to JSON.
///
/// - Properties:
///   - address1: The primary address line, typically including street and number.
///   - address2: An optional second line for the address (e.g., apartment or suite number).
///   - city: The city where the address is located.
///   - state: The state or province of the address.
///   - postcode: The postal or ZIP code.
///   - country: The country of the address.
struct Address: Codable {
    let address1: String?
    let address2: String?
    let city: String?
    let state: String?
    let postcode: String?
    let country: String?
}
