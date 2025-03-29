import Foundation

struct PetResponse: Codable {
    let animals: [Pet]
    let pagination: Pagination
}
